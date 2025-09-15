class NoticiasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable
  # TODO: Breakdown into smaller,
  # more readable methods
  def index
    scope = Noticia.includes(:caderno).published

    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      scope = scope.where(
        "LOWER(titulo) LIKE ? OR LOWER(chamada) LIKE ?", term, term
      )
    end

    if params[:cadernos].present?
      scope = scope.where(caderno: { permalink_pt: params[:cadernos] })
    end

    ordered = scope.order(created: :desc)
    @pagy, @noticias = pagy_infinite(ordered, params[:page])

    cadernos = Caderno.for_filters
    # Only set selectedCadernos if the param exists
    selected_filters = {}
    if params[:cadernos].present?
      selected_caderno = cadernos.find { |c| c["permalink_pt"] == params[:cadernos] }
      selected_filters[:cadernos] = selected_caderno if selected_caderno
    end

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
      cadernos: cadernos,
      breadcrumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Notícias", "" ],
      ),
      noticias: @noticias.as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ]
              ),
      pagy:  {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      },
      current_filters: selected_filters
    }
  end

  def show
    @noticia = Noticia.find_by_permalink(params[:permalink])
    render inertia: "Noticias/Show", props: {
      conteudo: @noticia.conteudo,
      titulo: @noticia.titulo,
      chamada: @noticia.chamada,
      rootUrl: @root_url,
      breadcrumbs: breadcrumbs(
        [ "Home", @root_url ],
        [ "Notícias", noticias_url ],
        [ @noticia.breadcrumb_title, "" ]
      )
    }
  end
end
