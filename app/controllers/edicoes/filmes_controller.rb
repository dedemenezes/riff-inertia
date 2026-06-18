class Edicoes::FilmesController < ApplicationController
  include Pagy::Backend
  include InfiniteScrollable
  include MostraFilterOptions

  PER_PAGE = 9

  before_action :set_edicao

  def index
    importacao_id = Importacao.where(edicao_id: @edicao.id).order(created: :desc).pick(:id)
    mostras = Mostra.where(importacao_id: importacao_id)

    base_scope = Pelicula.includes(:paises, :mostra, programacoes: :cinema)
                         .where(importacao_id: importacao_id)

    # Director/actor options intentionally follow the current legacy behavior:
    # they are not scoped to the previous edition's importacao.
    @pelicula_collection_service = PeliculaCollectionService.new
    set_mostra_filter_options(mostras, base_scope)

    filter_result = PeliculasFilter.new(
      relation: base_scope,
      params: params,
      filter_options: {
        mostras: @submostras_filter,
        paises: @paises_filter,
        genres: @genres_filter,
        directors: @directors_filter
      },
      pelicula_collection_service: @pelicula_collection_service,
      edicao_id: @edicao.id
    ).call

    filtered_relation = filter_result.relation.order(sort_column => sort_direction)

    current_page = params[:page]&.to_i || 1
    @pagy, @peliculas = pagy_infinite(filtered_relation, current_page, PER_PAGE)

    render inertia: "Edicoes/Filmes", props: {
      edicao: @edicao.as_json(only: %i[id descricao], methods: %i[cartazURL]),
      elements: @peliculas.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
      ),
      pagy: {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      },
      submostras: @submostras_filter,
      paises: @paises_filter,
      genres: @genres_filter,
      directors: @directors_filter,
      actors: @actors_filter,
      current_filters: {
        query: filter_result.selected_query,
        mostra: filter_result.selected_mostra,
        pais: filter_result.selected_pais,
        genero: filter_result.selected_genre,
        direcao: filter_result.selected_director,
        elenco: filter_result.selected_actor
      },
      has_active_filters: params.permit(:query, :mostra, :pais, :genero, :direcao, :elenco).to_h.values.any?(&:present?),
      sort: sort_direction.to_s,
      tabBaseUrl: edicao_anterior_filmes_path(@edicao),
      fallBackUrl: edicoes_anteriores_path,
      endMessage: I18n.t("infinite_scroll.end.filmes"),
      menuContext: set_menu_context.merge(
        "edicoes_anteriores" => edicoes_anteriores_menu_context(@edicao)
      ),
      activePage: I18n.t("navigation.todos_os_filmes")
    }
  end

  private

  def set_edicao
    @edicao = Edicao.find(params[:edicao_anterior_id])
  end

  def sort_direction
    params[:sort] == "desc" ? :desc : :asc
  end

  def sort_column
    I18n.locale == :en ? :titulo_ingles_coord_int : :titulo_portugues_coord_int
  end
end
