class NoticiasController < ApplicationController
  def show
    @noticia = Noticia.find_by_permalink(params[:permalink])
    # binding.b
    render inertia: "Noticias/Show", props: {
      conteudo: @noticia.conteudo,
      titulo: @noticia.titulo,
      chamada: @noticia.chamada
    }
  end
end
