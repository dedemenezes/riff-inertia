class CinemasController < ApplicationController
  include BreadcrumbsHelper

  def index
    @cinemas = Edicao.current.cinemas.order(nome: :asc)
    @salas = Cinema.group_salas(@cinemas)

    render inertia: "Cinemas/Index", props: {
      rootUrl: @root_url,
      cinemas: @salas.as_json,
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition.name", edicao_atual: Edicao.current.descricao), peliculas_path ],
        [ "Cinemas", cinemas_path ]
      )
    }
  end
end
