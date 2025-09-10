class ProgramsController < ApplicationController
  EDICAO_ATUAL = 12
  # TODO: MAKE THIS ENV VARIABLE?

  include BreadcrumbsHelper
  DATES_PER_PAGE = 1
  include Pagy::Backend

  def index
    items = [
      # Links tem que vir do controller para incluir localizacao. Textos também
      { name: I18n.t("navigation.programming"), route: program_url, icon: "program" },
      { name: I18n.t("navigation.sessoes_com_convidados"), route: "/", icon: "user" },
      { name: I18n.t("navigation.mudancas_na_programacao"), route: "/", icon: "change" },
      { name: I18n.t("navigation.sessoes_ao_ar_livre"), route: "/", icon: "clock" }
    ]

    selected_filters = {}
    last_import_id = Programacao.maximum(:importacoesprog_id)

    base_scope = Programacao
      .joins(pelicula: :mostra)
      .includes(:cinema, pelicula: :mostra)
      .where(importacoesprog_id: last_import_id, edicao_id: EDICAO_ATUAL) # TODO: remover importacoes?

    set_filter_options(base_scope)

    # Filtering SEARCH INPUT
    if params[:query].present?
      term = "%#{params[:query].downcase}%"
      pelicula_ids = Pelicula.where(edicao_id: EDICAO_ATUAL).where(
        "LOWER(titulo_ingles_coord_int) LIKE :term OR
        LOWER(titulo_original_coord_int) LIKE :term OR
        LOWER(titulo_portugues_coord_int) LIKE :term OR
        LOWER(titulo_ingles_semartigo) LIKE :term OR
        LOWER(titulo_portugues_semartigo) LIKE :term",
        term: term
      ).pluck(:id)

      base_scope = base_scope.where(pelicula_id: pelicula_ids)
      selected_query = { "filter_display": params[:query], "filter_value": params[:query] }
      selected_filters[:query] = selected_query
    end

    if params[:mostrasFilter].present?
      selected_mostra = @mostras_filter.find { |c| c["permalink_pt"] == params[:mostrasFilter] }
      selected_filters[:mostrasFilter] = selected_mostra if selected_mostra

      if selected_mostra
        base_scope = base_scope.where(mostras: { permalink_pt: selected_filters[:mostrasFilter]["permalink_pt"] })
      end
    end

    if params[:cinemasFilter]
      selected_cinema = @cinemas_filter.find do |cinema_filter|
        (cinema_filter["id"].to_s === params[:cinemasFilter]) && (cinema_filter["edicao_id"] == EDICAO_ATUAL)
      end
      if selected_cinema
        selected_filters[:cinemasFilter] = selected_cinema
        base_scope = base_scope.where(cinema_id: selected_cinema["id"])
      end
    end

    if params[:paisesFilter]
      selected_pais = @paises_filter.find do |pais_filter|
        (pais_filter["id"].to_s === params[:paisesFilter])
      end
      if selected_pais
        selected_filters[:paisesFilter] = selected_pais
        # base_scope = base_scope.where(paises_id: selected_pais["id"])
        base_scope = base_scope.joins(pelicula: :paises).where(pelicula: { paises: { id: selected_pais["id"] } })
      end
    end

    if params[:sessao].present?
      selected_sessao = @sessoes.find { |sessao| (sessao["filter_value"] === params[:sessao]) }

      if selected_sessao
        selected_filters[:sessao] = selected_sessao
        base_scope = base_scope.where(sessao: params[:sessao]..)
      end
    end

    if params[:genresFilter].present?
      selected_genre = @genres_filter.find { |genre| (genre["filter_value"] === params[:genresFilter]) }

      if selected_genre
        selected_filters[:genre] = selected_genre
        locale_index = I18n.locale == :en ? -1 : 1

        # Use subquery instead of raw SQL on joined table
        pelicula_ids = Pelicula.where(edicao_id: EDICAO_ATUAL).where(
          "SUBSTRING_INDEX(SUBSTRING_INDEX(catalogo_ficha_2007, ' ', 1), '/', ?) LIKE ?",
          locale_index,
          "%#{selected_genre['filter_value']}%"
        ).pluck(:id)

        base_scope = base_scope.where(pelicula_id: pelicula_ids)
      end
    end

    # Get Scope Available dates
    available_dates = base_scope.distinct.pluck(:data).sort
    selected_date = available_dates.first

    # Filter by date
    if params[:date].present?
      parsed_date = Date.parse(params[:date]) rescue nil
      if parsed_date&.in?(available_dates)
        selected_date = parsed_date
      end
    end
    selected_filters[:date] = selected_date

    programacoes_for_date = base_scope.where(data: selected_date).order(:sessao)

    current_page = params[:page].to_i ||= 1

    @pagy, @programacoes = pagy_infinite(programacoes_for_date, current_page)

    @programacoes = @programacoes.map do |programacao|
      {
        id: programacao.id,
        data: programacao.data,
        sessao: [ programacao.display_sessao ],
        cinema: programacao.cinema&.nome,
        titulo: programacao.pelicula&.titulo_portugues_coord_int,
        duracao: programacao.pelicula&.duracao_coord_int,
        imagem: programacao.pelicula&.imagem,
        genero: programacao.pelicula&.genre,
        paises: programacao.pelicula&.display_paises,
        mostra: programacao.pelicula&.mostra&.display_name,
        mostra_tag_class: programacao.pelicula&.mostra&.tag_class
      }
    end

    # display_selected_date = I18n.l(selected_date, format: "%a, %e %b", locale: :pt) if selected_date
    @menu_tabs = available_dates.map do |date|
      {
        date: date,
        url: build_tab_url(date, selected_filters),
        active: date.to_s == params[:date] || (date == selected_date && !params[:date])
      }
    end

    # Build breadcrumbs
    render inertia: "ProgramPage", props: {
      rootUrl: @root_url,
      tabBaseUrl: program_url,
      items:,
      elements: @programacoes,
      pagy: @pagy,
      mostrasFilter: @mostras_filter,
      cinemasFilter: @cinemas_filter,
      paisesFilter: @paises_filter,
      genresFilter: @genres_filter,
      sessoes: @sessoes,
      menuTabs: @menu_tabs,
      current_filters: { # those are the ones used as modelValue
        query: selected_query,
        mostrasFilter: selected_mostra,
        cinemasFilter: selected_cinema,
        paisesFilter: selected_pais,
        genresFilter: selected_genre,
        sessao: selected_sessao
      },
      has_active_filters: params.permit(:query, :mostrasFilter).to_h.values.any?(&:present?),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Programação", "" ],
        [ "Programação Completa", "" ],
      ),
    }
  end

  private

  # TODO: Relocate this piece into a concern or helper
  def pagy_infinite(collection, page_param)
    current_page = (page_param || params[:page] || 1).to_i
    limit = Pagy::DEFAULT[:limit] || 5

    if current_page <= 1
      # First page - normal pagination
      pagy_result = pagy(collection, limit: limit)
      pagy_result
    else
      # Infinite scroll - load all items from page 1 to current page
      total_items_needed = current_page * limit

      # Get the actual items
      items = collection.limit(total_items_needed)

      # Create proper pagy object with
      # all the metadata need in the frontend
      total_count = collection.count
      pagy_obj = Pagy.new(
        count: total_count,
        limit: limit,
        page: current_page,
        # overflow: :last_page
      )

      [ pagy_obj, items ]
    end
  end

  def build_tab_url(date, filters)
    query_params = {}
    query_params[:mostrasFilter]= filters[:mostrasFilter]["permalink_pt"] if filters[:mostrasFilter].present?
    query_params[:cinemasFilter]= filters[:cinemasFilter]["id"] if filters[:cinemasFilter].present?
    query_params[:paisesFilter]= filters[:paisesFilter]["id"] if filters[:paisesFilter].present?
    query_params[:sessao]= filters[:sessao]["filter_value"] if filters[:sessao].present?
    query_params[:date] = date
    url_for(params: query_params, only_path: true)
  end

  def set_filter_options(base_scope)
    @paises_filter   = base_scope.includes(pelicula: :paises)
                                .map { _1.pelicula.paises }
                                .flatten
                                .uniq
                                .sort_by { |it| it.nome_pais }
                                .as_json(
                                  only: %i[id nome_pais],
                                  methods: %i[filter_display filter_value]
                                )

    @mostras_filter  = Mostra.where(edicao_id: EDICAO_ATUAL)
                            .to_a
                            .uniq { |m| m.id }
                            .sort_by { |it| it.permalink_pt }
                            .as_json(
                              only: %i[id permalink_pt nome_abreviado],
                              methods: [ :tag_class, :display_name, :filter_value, :filter_display ]
                            )
    @cinemas_filter = Cinema.where(edicao_id: EDICAO_ATUAL)
                            .to_a
                            .uniq { |m| m.id }
                            .sort_by { |it| it.nome }
                            .as_json(
                              only: %i[id nome endereco edicao_id],
                              methods: %i[filter_display filter_value]
                            )

    @sessoes = Programacao.where(edicao_id: EDICAO_ATUAL).to_a.uniq { |p| p.sessao }.sort.as_json(
      only: %i[sessao],
      methods: %i[display_sessao filter_value filter_display]
    )

    @genres_filter = Pelicula.genres_for(EDICAO_ATUAL)
  end
end
