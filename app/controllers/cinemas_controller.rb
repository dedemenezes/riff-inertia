class CinemasController < ApplicationController
  include BreadcrumbsHelper

  def index
    @edicao_atual = Edicao.find_by(descricao: ApplicationRecord::EDICAO_ATUAL_ANO)
    @cinemas = @edicao_atual.cinemas.order(nome: :asc)
    @salas = Cinema.group_salas(@cinemas)

    render inertia: "Cinemas/Index", props: {
      rootUrl: @root_url,
      cinemas: @salas.as_json,
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition2024"), peliculas_path ],
        [ "Cinemas", cinemas_path ]
      )
    }
  end
end
