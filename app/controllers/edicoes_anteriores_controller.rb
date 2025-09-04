class EdicoesAnterioresController < ApplicationController
  def index
    @edicoes = Edicao.all.order(data_inicio: :desc).offset(1)

    # TODO: mudar links
    items = [
      # Links tem que vir do controller para incluir localizacao. Textos também
      { name: "O Festival", route: "/", icon: "program" },
      { name: "Edições Anteriores", route: edicoes_anteriores_url, icon: "user" },
      { name: "Talent Press", route: "/", icon: "change" },
      { name: "Parceiros", route: "/", icon: "clock" }
    ]

    render inertia: "Edicoes/Index", props: {
      rootUrl: @root_url,
      items: items,
      edicoes: @edicoes.as_json(
                only: %i[id descricao cartaz],
                methods: [ ]
              )
    }
  end
end
