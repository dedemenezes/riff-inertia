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
      .where(importacoesprog_id: last_import_id) # ALTERAR PARA EDICAO ID

    # Filtering SEARCH INPUT
    if params[:query].present?
      term = "%#{params[:query].downcase}%"
      base_scope = base_scope.where(
        "LOWER(peliculas.titulo_ingles_coord_int) LIKE :query OR
        LOWER(peliculas.titulo_original_coord_int) LIKE :query OR
        LOWER(peliculas.titulo_portugues_coord_int) LIKE :query OR
        LOWER(peliculas.titulo_ingles_semartigo) LIKE :query OR
        LOWER(peliculas.titulo_portugues_semartigo) LIKE :query",
        query: term
      )
      selected_filters[:query] = params[:quer]
    end

    # Gathering filter options
    mostras_filter = Mostra.where(edicao_id: 12).to_a.uniq { |m| m.id }.sort_by { _1.permalink_pt }.as_json(
      only: %i[id permalink_pt nome_abreviado],
      methods: [ :tag_class, :display_name ]
    )
    cinemas_filter = Cinema.where(edicao_id: EDICAO_ATUAL).to_a.uniq { |m| m.id }.sort_by { |it| it.nome }.as_json(
      only: %i[id nome endereco edicao_id]
    )

    if params[:mostrasFilter].present?
      selected_mostra = mostras_filter.find { |c| c["permalink_pt"] == params[:mostrasFilter] }
      selected_filters[:mostrasFilter] = selected_mostra if selected_mostra

      if selected_mostra
        base_scope = base_scope.where(mostras: { permalink_pt: selected_filters[:mostrasFilter]["permalink_pt"] })
      end
    end

    if params[:cinemasFilter]
      selected_cinema = cinemas_filter.find do |cinema_filter|
        (cinema_filter["id"] === params[:cinemasFilter].to_i) && (cinema_filter["edicao_id"] == EDICAO_ATUAL)
      end
      if selected_cinema
        selected_filters[:cinemasFilter] = selected_cinema
        base_scope = base_scope.where(cinema_id: selected_cinema["id"])
      end
    end

    available_dates = base_scope.distinct.pluck(:data).sort
    selected_date = available_dates.first

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

    @programacoes = @programacoes.map do |p|
      {
        id: p.id,
        data: p.data,
        sessao: [ p.display_sessao ],
        cinema: p.cinema&.nome,
        titulo: p.pelicula&.titulo_portugues_coord_int,
        duracao: p.pelicula&.duracao_coord_int,
        imagem: p.pelicula&.imagem,
        genero: p.pelicula&.genre,
        mostra: p.pelicula&.mostra&.display_name,
        mostra_tag_class: p.pelicula&.mostra&.tag_class
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
      mostrasFilter: mostras_filter,
      cinemaOptions: cinemas_filter,
      menuTabs: @menu_tabs,
      current_filters: {
        query: params[:query],
        mostrasFilter: selected_mostra
      },
      has_active_filters: params.permit(:query, :mostrasFilter).to_h.values.any?(&:present?),
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
    query_params[:mostrasFilter]= filters[:mostrasFilter]["permalink_pt"] if filters[:mostrasFilter].present?
    query_params[:date] = date
    url_for(params: query_params, only_path: true)
  end
end
