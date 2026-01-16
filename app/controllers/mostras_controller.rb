class MostrasController < ApplicationController
  def index
    @mostras = Mostra.includes(:peliculas).where(edicao_id: @current_edicao.id).group_by(&:display_name)
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
    @mostras = @current_edicao.mostras.select { |mostra| mostra.display_name == params[:category] }

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
