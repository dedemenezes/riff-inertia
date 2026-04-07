class NoticiasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable

  def index
    @idioma = Idioma.find_by("locale LIKE ?", "#{I18n.locale}%")
    base_scope = Noticia.includes(:caderno).where(idioma: @idioma).published

    # if params[:search].present?
    #   term = "%#{params[:search].downcase}%"
    #   scope = scope.where(
    #     "LOWER(titulo) LIKE ? OR LOWER(chamada) LIKE ?", term, term
    #   )
    # end

    filter_result = NoticiasFilter.new(
      relation: base_scope,
      params: params,
      locale: I18n.locale
    ).call

    current_page = params[:page].to_i
    current_page = 1 if current_page < 1

    ordered = filter_result.relation.order(created: :desc)
    @pagy, @noticias = pagy_infinite(ordered, current_page)

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
      tabBaseUrl: noticias_url,
      dataLabel: I18n.t("filter.date"),
      cadernos: filter_result.cadernos,
      breadcrumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Notícias", "" ],
      ),
      elements: @noticias.as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ]
              ),
      pagy:  {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      },
      current_filters: {
        data: filter_result.selected_date,
        caderno: filter_result.selected_caderno
      }
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
