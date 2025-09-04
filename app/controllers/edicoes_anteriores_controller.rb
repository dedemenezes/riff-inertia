class EdicoesAnterioresController < ApplicationController
  def index
    @edicoes = Edicao.all - [Edicao.last]

    render inertia: "Edicoes/Index", props: {
      rootUrl: @root_url,
      edicoes: @edicoes.as_json(
                only: %i[id descricao cartaz],
                methods: [ ]
              )
    }
  end
end
