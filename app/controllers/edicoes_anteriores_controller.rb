class EdicoesAnterioresController < ApplicationController
  def index
    @edicoes = Edicao.all.order(descricao: :desc).offset(1)

    render inertia: "Edicoes/Index", props: {
      rootUrl: @root_url,
      edicoes: @edicoes.as_json(
                only: %i[id descricao cartaz],
                methods: []
              )
    }
  end
end
