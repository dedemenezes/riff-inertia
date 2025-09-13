class PeliculasController < ApplicationController
  include BreadcrumbsHelper

  def index
    @edicao_atual = Edicao.find_by(descricao: ApplicationRecord::EDICAO_ATUAL_ANO)
    @peliculas = @edicao_atual.peliculas.order(titulo_portugues_coord_int: :asc)

    render inertia: "Peliculas/Index", props: {
      rootUrl: @root_url,
      peliculas: @peliculas.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
      ),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition2024"), "" ],
        [ "Todos os Filmes", peliculas_path ]
      )
    }
  end

  def show
    @pelicula = Pelicula.find_by(edicao_id: 12, permalink: params[:permalink])
    render inertia: "Peliculas/Show", props: {
      rootUrl: @root_url,
      pelicula: @pelicula.as_json(
        only: Pelicula::COLUMNS_NEEDED,
        methods: Pelicula::METHODS_NEEDED
      ),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.programming"), program_path ],
        [ @pelicula.display_titulo, "" ]
      ),
      backPath: request.referer || root_path
    }
  end
end
