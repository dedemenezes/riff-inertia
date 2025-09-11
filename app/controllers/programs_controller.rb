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

    if params[:mostra].present?
      selected_mostra = @mostras_filter.find { |c| c["permalink_pt"] == params[:mostra] }
      selected_filters[:mostra] = selected_mostra if selected_mostra

      if selected_mostra
        base_scope = base_scope.where(mostras: { permalink_pt: selected_filters[:mostra]["permalink_pt"] })
      end
    end

    if params[:cinema]
      selected_cinema = @cinemas_filter.find do |cinema_filter|
        (cinema_filter["id"].to_s === params[:cinema]) && (cinema_filter["edicao_id"] == EDICAO_ATUAL)
      end
      if selected_cinema
        selected_filters[:cinema] = selected_cinema
        base_scope = base_scope.where(cinema_id: selected_cinema["id"])
      end
    end

    if params[:pais]
      selected_pais = @paises_filter.find do |pais_filter|
        (pais_filter["id"].to_s === params[:pais])
      end
      if selected_pais
        selected_filters[:pais] = selected_pais
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

    if params[:genre].present?
      selected_genre = @genres_filter.find { |genre| (genre["filter_value"] === params[:genre]) }

      if selected_genre
        selected_filters[:genre] = selected_genre
        locale_index = I18n.locale == :en ? -1 : 1

        # substring index is used to split the text in the database and select by index
        base_scope = base_scope.where(
          "SUBSTRING_INDEX(SUBSTRING_INDEX(peliculas.catalogo_ficha_2007, ' ', 1), '/', ?) LIKE ?",
          locale_index,
          "%#{selected_genre['filter_value']}%"
        )
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
      mostras: @mostras_filter,
      cinemas: @cinemas_filter,
      paises: @paises_filter,
      genres: @genres_filter,
      sessoes: @sessoes,
      directors: @directors_filter,
      actors: @actors_filter,
      menuTabs: @menu_tabs,
      current_filters: { # those are the ones used as modelValue
        query: selected_query,
        mostra: selected_mostra,
        cinema: selected_cinema,
        pais: selected_pais,
        genre: selected_genre,
        sessao: selected_sessao,
        elenco: selected_actor,
        "direção" => selected_director
      },
      has_active_filters: params.permit(:query, :mostra).to_h.values.any?(&:present?),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Programação", "" ],
        [ "Programação Completa", "" ],
      )
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
    query_params[:mostra]= filters[:mostra]["filter_value"] if filters[:mostra].present?
    query_params[:cinema]= filters[:cinema]["filter_value"] if filters[:cinema].present?
    query_params[:pais]= filters[:pais]["filter_value"] if filters[:pais].present?
    query_params[:genre]= filters[:genre]["filter_value"] if filters[:genre].present?
    query_params[:sessao]= filters[:sessao]["filter_value"] if filters[:sessao].present?
    query_params["direção"]= filters["direção"]["filter_value"] if filters["direção"].present?
    query_params[:elenco]= filters[:elenco]["filter_value"] if filters[:elenco].present?
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
    @directors_filter = Pelicula.directors_for(EDICAO_ATUAL)
  end
end
