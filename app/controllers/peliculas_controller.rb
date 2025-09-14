class PeliculasController < ApplicationController
  include BreadcrumbsHelper

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
        [ I18n.t("navigation.programming"), program_path ],
        [ @pelicula.display_titulo, "" ]
      ),
      backPath: request.referer || root_path
    }
  end
end
