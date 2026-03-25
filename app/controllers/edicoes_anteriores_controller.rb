class EdicoesAnterioresController < ApplicationController
  include BreadcrumbsHelper

  def index
    @edicoes = Edicao.all.order(descricao: :desc).offset(1)

    render inertia: "Edicoes/Index", props: {
      rootUrl: @root_url,
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.festival.name"), "#" ],
        [ I18n.t("navigation.edicoes_anteriores"), edicoes_anteriores_path ]
      ),
      edicoes: @edicoes.as_json(
                only: %i[id descricao cartaz],
                methods: []
              )
    }
  end
end
