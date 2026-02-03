class PeliculasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable

  def index
    @peliculas = Pelicula
                  .includes(programacoes: :cinema)
                  .where(edicao: @current_edicao)
                  .order(titulo_portugues_coord_int: :asc)

    current_page = params[:page]&.to_i || 1

    if params[:query]
      term = "%#{params[:query].downcase}%"
      @peliculas = @peliculas.where(edicao_id: ApplicationRecord::EDICAO_ATUAL).where(
        "LOWER(titulo_ingles_coord_int) LIKE :term OR
        LOWER(titulo_original_coord_int) LIKE :term OR
        LOWER(titulo_portugues_coord_int) LIKE :term OR
        LOWER(titulo_ingles_semartigo) LIKE :term OR
        LOWER(titulo_portugues_semartigo) LIKE :term",
        term: term
      )
      current_page = 1
    end

    pagy_limit = 9
    @pagy, @peliculas = pagy_infinite(@peliculas, current_page, pagy_limit)

    render inertia: "Peliculas/Index", props: {
      rootUrl: @root_url,
      elements: @peliculas.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
      ),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition.name"), "" ],
        [ I18n.t("navigation.todos_os_filmes"), peliculas_path ]
      ),
      pagy:  {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      }
    }
  end

  def show
    @pelicula = Pelicula.includes(:paises, :mostra, programacoes: :cinema).find_by(edicao_id: 12, permalink: params[:permalink])
    render inertia: "Peliculas/Show", props: {
      rootUrl: @root_url,
      pelicula: @pelicula.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
      ),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.programming.name"), program_path ],
        [ @pelicula.display_titulo, "" ]
      ),
      backPath: request.referer || root_path
    }
  end
end
