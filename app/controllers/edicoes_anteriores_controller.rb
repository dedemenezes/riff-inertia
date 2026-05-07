class EdicoesAnterioresController < ApplicationController
  include BreadcrumbsHelper

  def index
    @edicoes = Edicao.all.order(descricao: :desc).offset(1)

    render inertia: "Edicoes/Index", props: {
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.festival.name"), "#" ],
        [ I18n.t("navigation.edicoes_anteriores"), edicoes_anteriores_path ]
      ),
      edicoes: @edicoes.as_json(
                only: %i[id descricao cartaz],
                methods: [ :cartazURL ]
              )
    }
  end
end
