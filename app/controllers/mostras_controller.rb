class MostrasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable
  include MostraFilterOptions

  def index
    importacao_id = current_importacao_id
    @mostras = Mostra.includes(:peliculas).where(importacao_id: importacao_id).group_by(&:display_name)
    @categorias = @mostras.map { |categoria, mostras| {
      name: categoria,
      class: mostras.first.tag_class,
      path: mostra_path(mostras.first.permalink_pt),
      mostraImageURL: mostras.first.peliculas.sample&.imageURL
    } }

    render inertia: "Mostras/Index", props: {
      categorias: @categorias.as_json,
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition.name", edicao_atual: Edicao.current.descricao), "" ],
        [ I18n.t("navigation.mostras"), mostras_path ]
      )
    }
  end

  def show
    @mostras = mostra_scope_for(params[:category], current_importacao_id)
    return head :not_found if @mostras.empty?

    mostra_ids = @mostras.map(&:id)

    base_scope = Pelicula.includes(:paises, :mostra, programacoes: :cinema)
                         .where(importacao_id: @mostras.first.importacao_id, mostra_id: mostra_ids)

    @pelicula_collection_service = PeliculaCollectionService.new(
      Pelicula.where(mostra_id: mostra_ids)
    )
    set_mostra_filter_options(@mostras, base_scope)

    filter_result = PeliculasFilter.new(
      relation: base_scope,
      params: params,
      filter_options: {
        mostras: @submostras_filter,
        paises: @paises_filter,
        genres: @genres_filter,
        directors: @directors_filter
      },
      pelicula_collection_service: @pelicula_collection_service
    ).call

    filtered_relation = filter_result.relation.order(titulo_portugues_coord_int: :asc)

    current_page = params[:page]&.to_i || 1
    @pagy, @peliculas = pagy_infinite(filtered_relation, current_page, 9)

    render inertia: "Mostras/Show", props: {
      categoria: @mostras.first.display_name,
      tag_class: @mostras.first.tag_class,
      tabBaseUrl: mostra_path(@mostras.first.permalink_pt),
      mostras: @mostras.as_json(only: %i[id nome_abreviado imagem]),
      submostras: @submostras_filter,
      paises: @paises_filter,
      genres: @genres_filter,
      directors: @directors_filter,
      actors: @actors_filter,
      elements: @peliculas.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
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
      verFilmesLabel: I18n.t("mostras.show.ver_filmes")
    }
  end

  private

  def current_importacao_id
    Importacao.where(edicao_id: Edicao.current.id).order(created: :desc).pick(:id)
  end

  def mostra_scope_for(category, importacao_id)
    mostra = Mostra.where(importacao_id: importacao_id)
                  .find_by(permalink_pt: category) ||
      Mostra.where(importacao_id: importacao_id)
            .find_by(permalink_en: category)
    return grouped_mostras_for(mostra, importacao_id) if mostra

    current_mostras_for(category, importacao_id)
  end

  def grouped_mostras_for(mostra, importacao_id)
    display_name = mostra.display_name
    Mostra.where(importacao_id: importacao_id)
          .where(
            "nome_abreviado = :cat OR nome_abreviado LIKE :pre_dash OR nome_abreviado LIKE :pre_colon",
            cat: display_name,
            pre_dash: "#{display_name}-%",
            pre_colon: "#{display_name}:%"
          )
  end

  def current_mostras_for(category, importacao_id)
    Mostra.where(importacao_id: importacao_id).where(
      "nome_abreviado = :cat OR nome_abreviado LIKE :pre_dash OR nome_abreviado LIKE :pre_colon",
      cat: category,
      pre_dash: "#{category}-%",
      pre_colon: "#{category}:%"
    )
  end
end
