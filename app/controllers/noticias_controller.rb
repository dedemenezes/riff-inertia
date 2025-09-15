class NoticiasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend
  include InfiniteScrollable
  # TODO: Breakdown into smaller,
  # more readable methods
  before_action :set_filter_options, only: :index

  def index
    scope = Noticia.includes(:caderno).published
    selected_filters = {}

    # if params[:search].present?
    #   term = "%#{params[:search].downcase}%"
    #   scope = scope.where(
    #     "LOWER(titulo) LIKE ? OR LOWER(chamada) LIKE ?", term, term
    #   )
    # end

    if params[:data]
      selected_date = { filter_display: params[:data], filter_value: params[:data], filter_label: I18n.t("filter.date") }
      date_range = (Date.parse(selected_date[:filter_value])..Date.today)
      scope = scope.where(data: date_range)
    end

    if params[:caderno].present?
      selected_caderno = @cadernos.find { |c| c["filter_value"] == params[:caderno] }
      selected_filters[:caderno] = selected_caderno if selected_caderno
      if I18n.locale == :pt
        scope = scope.where(caderno: { permalink_pt: params[:caderno] })
      else
        scope = scope.where(caderno: { permalink_en: params[:caderno] })
      end
    end

    current_page = params[:page].to_i ||= 1

    ordered = scope.order(created: :desc)
    @pagy, @noticias = pagy_infinite(ordered, current_page)

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
      tabBaseUrl: noticias_url,
      dataLabel: I18n.t("filter.date"),
      cadernos: @cadernos,
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
        data: selected_date,
        caderno: selected_caderno
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

  private

  def set_filter_options
    # cadernos = Caderno.for_filters
    if I18n.locale == :pt
      @cadernos = Caderno.collection_without_edition_for(:permalink_pt, :nome_pt, :caderno)
    else
      @cadernos = Caderno.collection_without_edition_for(:permalink_en, :nome_en, :caderno)
    end
  end
end
