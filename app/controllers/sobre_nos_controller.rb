# frozen_string_literal: true

class SobreNosController < ApplicationController
  include BreadcrumbsHelper

  def index
    @pagina = Pagina.find_by(rota: "/br/o-festival/", permalink: "quem-somos")

    render inertia: "SobreNos/Index", props: {
      titulo: @pagina&.titulo,
      conteudo: @pagina&.conteudo,
      breadcrumbs: breadcrumbs(
        [ I18n.t("navigation.home"), @root_url ],
        [ I18n.t("navigation.about.name"), "" ]
      )
    }
  end
end
