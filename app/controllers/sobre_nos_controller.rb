# frozen_string_literal: true

class SobreNosController < ApplicationController
  include BreadcrumbsHelper

  def index
    @pagina = Pagina.find_by(rota: "/br/o-festival/", permalink: "quem-somos")

    render inertia: "SobreNos/Index", props: {
      titulo: @pagina&.titulo,
      conteudo: @pagina&.conteudo,
      breadcrumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Sobre nós", "" ]
      )
    }
  end
end
