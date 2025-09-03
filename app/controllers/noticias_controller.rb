class NoticiasController < ApplicationController
  include BreadcrumbsHelper

  def show
    @noticia = Noticia.find_by_permalink(params[:permalink])
    # binding.b
    render inertia: "Noticias/Show", props: {
      conteudo: @noticia.conteudo,
      titulo: @noticia.titulo,
      chamada: @noticia.chamada,
      rootUrl: @root_url,
      breadcrumbs: breadcrumbs(
        [ "Home", @root_url ],
        [ "Notícias", noticia_url(@noticia) ],
        [ @noticia.titulo, "" ]
      )
    }
  end
end
