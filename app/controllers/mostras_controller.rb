class MostrasController < ApplicationController
  def index
    # @edicao_atual = Edicao.find_by(descricao: ApplicationRecord::EDICAO_ATUAL_ANO)
    @mostras = Mostra.includes(:peliculas).where(edicao_id: ApplicationRecord::EDICAO_ATUAL).group_by(&:display_name)
    @categorias = @mostras.map { |categoria, mostras| {
      name: categoria,
      class: mostras.first.tag_class,
      path: mostra_path(categoria),
      mostraImageURL: mostras.first.peliculas.sample.imageURL
    } }

    render inertia: "Mostras/Index", props: {
      rootUrl: @root_url,
      categorias: @categorias.as_json
    }
  end

  def show
    @edicao_atual = Edicao.find_by(descricao: "2024") # TODO: Change to 2025
    @mostras = @edicao_atual.mostras.select { |mostra| mostra.display_name == params[:category] }

    render inertia: "Mostras/Show", props: {
      rootUrl: @root_url,
      categoria: params[:category],
      tag_class: @mostras.first.tag_class,
      mostras: @mostras.as_json(
                  only: %i[id nome_abreviado imagem],
                  methods: []
                 )
    }
  end
end
