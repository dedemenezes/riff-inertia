class MostrasController < ApplicationController
  before_action :set_items

  def index
    @edicao_atual = Edicao.find_by(descricao: "2024") # TODO: Change to 2025
    @mostras = @edicao_atual.mostras.group_by(&:display_name)
    @categorias = @mostras.map { |categoria, mostras| { name: categoria, class: mostras.first.tag_class, path: mostra_path(categoria) } }

    render inertia: "Mostras/Index", props: {
      rootUrl: @root_url,
      items: @items,
      categorias: @categorias.as_json
    }
  end

  def show
    @edicao_atual = Edicao.find_by(descricao: "2024") # TODO: Change to 2025
    @mostras = @edicao_atual.mostras.select { |mostra| mostra.display_name == params[:category] }

    render inertia: "Mostras/Show", props: {
      rootUrl: @root_url,
      items: @items,
      categoria: params[:category],
      tag_class: @mostras.first.tag_class,
      mostras: @mostras.as_json(
                  only: %i[id nome_abreviado imagem],
                  methods: []
                 )
    }
  end

  private

  def set_items
    @items = [
      # Links tem que vir do controller para incluir localizacao. Textos também
      { name: "Todos os Filmes", route: "/", icon: "program" },
      { name: "Mostras", route: mostras_url, icon: "user" },
      { name: "Cinemas", route: "/", icon: "change" },
      { name: "Juri", route: "/", icon: "clock" },
      { name: "Equipe", route: "/", icon: "clock" }
    ]
  end
end
