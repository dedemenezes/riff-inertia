class Edicoes::MostrasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable
  include MostraFilterOptions

  PER_PAGE = 9
  PREMIERE_BRASIL_NAME = "Première Brasil"
  FILM_COLUMNS = %i[edicao_id duracao_coord_int].freeze
  FILM_METHODS = %i[
    display_titulo
    genre
    display_paises
    imageURL
    mostra_tag_class
    mostra_display_name
  ].freeze

  before_action :set_edicao

  def index
    ultima_importacao_id = latest_importacao_id
    @mostras = Mostra.includes(:peliculas).where(importacao_id: ultima_importacao_id).group_by(&:display_name)

    @categorias = @mostras.map { |categoria, mostras| {
      name: categoria,
      class: mostras.first.tag_class,
      path: categoria_path(categoria, mostras.first),
      mostraImageURL: mostras.first.peliculas.sample&.imageURL
    } }
    render inertia: "Edicoes/Mostras", props: {
      edicao: @edicao.as_json(only: %i[id descricao], methods: %i[cartazURL]),
      categorias: @categorias.as_json,
      menuContext: set_menu_context.merge(
        "edicoes_anteriores" => edicoes_anteriores_menu_context(@edicao)
      ),
      fallBackUrl: edicoes_anteriores_path
    }
  end

  def premiere_brasil
    importacao_id = latest_importacao_id
    @mostras = Mostra.where(importacao_id: importacao_id)
                     .where(
                       "nome_abreviado = :cat OR nome_abreviado LIKE :pre_dash OR nome_abreviado LIKE :pre_colon",
                       cat: PREMIERE_BRASIL_NAME,
                       pre_dash: "#{PREMIERE_BRASIL_NAME}-%",
                       pre_colon: "#{PREMIERE_BRASIL_NAME}:%"
                     )
                     .order(:permalink_pt)

    return head :not_found if @mostras.empty?

    render_mostra_show(
      mostras: @mostras,
      categoria: PREMIERE_BRASIL_NAME,
      tab_base_url: edicao_anterior_mostras_premiere_brasil_path(@edicao)
    )
  end

  def show
    importacao_id = latest_importacao_id
    mostra = Mostra.where(importacao_id: importacao_id)
                  .find_by(
                    "permalink_pt = :permalink OR permalink_en = :permalink",
                    permalink: params[:permalink]
                  )

    return head :not_found unless mostra

    render_mostra_show(
      mostras: Mostra.where(id: mostra.id),
      categoria: mostra.display_name,
      tab_base_url: edicao_anterior_mostra_path(@edicao, mostra)
    )
  end

  private

  def render_mostra_show(mostras:, categoria:, tab_base_url:)
    mostras = mostras.to_a
    mostra_ids = mostras.map(&:id)
    base_scope = Pelicula.includes(:paises, :mostra)
                         .where(importacao_id: latest_importacao_id, mostra_id: mostra_ids)

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

    filtered_relation = filter_result.relation.order(sort_column => :asc)
    current_page = [ params[:page].to_i, 1 ].max
    @pagy, @peliculas = pagy_infinite(filtered_relation, current_page, PER_PAGE)

    render inertia: "Edicoes/Mostras/Show", props: {
      edicao: @edicao.as_json(only: %i[id descricao], methods: %i[cartazURL]),
      fallBackUrl: edicoes_anteriores_path,
      activePage: I18n.t("navigation.mostras"),
      categoria: categoria,
      tag_class: mostras.first.tag_class,
      tabBaseUrl: tab_base_url,
      mostras: mostras.as_json(only: %i[id nome_abreviado imagem]),
      submostras: @submostras_filter,
      paises: @paises_filter,
      genres: @genres_filter,
      directors: @directors_filter,
      actors: @actors_filter,
      elements: @peliculas.as_json(
        only: FILM_COLUMNS,
        methods: FILM_METHODS
      ),
      pagy: {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      },
      current_filters: {
        query: filter_result.selected_query,
        mostra: filter_result.selected_mostra,
        pais: filter_result.selected_pais,
        genero: filter_result.selected_genre,
        direcao: filter_result.selected_director,
        elenco: filter_result.selected_actor
      },
      has_active_filters: params.permit(:query, :mostra, :pais, :genero, :direcao, :elenco).to_h.values.any?(&:present?),
      endMessage: I18n.t("infinite_scroll.end.filmes"),
      verFilmesLabel: I18n.t("mostras.show.ver_filmes"),
      menuContext: set_menu_context.merge(
        "edicoes_anteriores" => edicoes_anteriores_menu_context(@edicao)
      )
    }
  end

  def set_edicao
    @edicao = Edicao.find(params[:edicao_anterior_id])
  end

  def latest_importacao_id
    Importacao.where(edicao_id: @edicao.id).order(created: :desc).pick(:id)
  end

  def categoria_path(categoria, mostra)
    if categoria.parameterize == "premiere-brasil"
      edicao_anterior_mostras_premiere_brasil_path(@edicao)
    else
      edicao_anterior_mostra_path(@edicao, mostra)
    end
  end

  def sort_column
    I18n.locale == :en ? :titulo_ingles_coord_int : :titulo_portugues_coord_int
  end
end
