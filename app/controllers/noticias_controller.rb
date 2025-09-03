class NoticiasController < ApplicationController
  include BreadcrumbsHelper

  def index
    # TODO: Utilizar paginação ou automatic scroll
    @noticias = Noticia.includes(:caderno).order(created: :desc).first(10)

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
      breadcrumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Notícias", "" ],
      ),
      noticias: @noticias.as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ]
              )
    }
  end

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
        [ "Notícias", noticias_url ],
        [ @noticia.titulo, "" ]
      )
    }
  end
end
