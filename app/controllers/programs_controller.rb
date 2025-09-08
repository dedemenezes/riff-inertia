class ProgramsController < ApplicationController
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

    last_import_id = Programacao.maximum(:importacoesprog_id)

    base_scope = Programacao
      .joins(:pelicula)
      .includes(:cinema, pelicula: :mostra)
      .where(importacoesprog_id: last_import_id)

    # Filtering
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
    end

    available_dates = base_scope.distinct.pluck(:data).sort
    selected_date = available_dates.first

    if params[:date].present?
      parsed_date = Date.parse(params[:date]) rescue nil
      selected_date = parsed_date if parsed_date&.in?(available_dates)
    end

    # Gathering filter options
    mostras_filter = Mostra.where(edicao_id: 12).to_a.uniq { |m| m.display_name }.as_json(
      only: %i[id permalink_pt nome_abreviado],
      methods: [ :tag_class, :display_name ]
    )

    selected_filters = {}
    if params[:mostrasFilter].present?
      selected_mostra = mostras_filter.find { |c| c["tag_class"] == params[:mostrasFilter] }
      selected_filters[:mostrasFilter] = selected_mostra if selected_mostra

      # Get the IDs
      # Query programacoes via SQL using mostra_ids
      binding.b
      base_scope = base_scope.where(pelicula: { mostra_id: selected_filters[:mostrasFilter]["id"] })
      binding.b
    end

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

    display_selected_date = I18n.l(selected_date, format: "%a, %e %b", locale: :pt) if selected_date

    render inertia: "ProgramPage", props: {
      rootUrl: @root_url,
      items:,
      available_dates:,
      selected_date: display_selected_date,
      elements: @programacoes,
      pagy: @pagy,
      tabBaseUrl: program_url,
      searchQuery: params[:query],
      selectedFilters: selected_filters,
      mostrasFilter: mostras_filter
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
end
