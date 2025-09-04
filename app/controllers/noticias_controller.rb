class NoticiasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend

  # TODO: Breakdown into smaller,
  # more readable methods
  def index
    mainItems = [
      I18n.t("navigation.programming"),
      I18n.t("navigation.edition2024"),
      I18n.t("navigation.aboutUs"),
      I18n.t("navigation.news"),
      I18n.t("navigation.media"),
      I18n.t("navigation.information")
    ]

    secondaryItems = [
      { name: I18n.t("navigation.press"), tag: "a", href: root_url },
      { name: I18n.t("navigation.archive"), tag: "a", href: "https://www.globo.com" },
      { name: I18n.t("navigation.registrations"), tag: "a", href: root_url },
      { name: I18n.t("navigation.contact"), tag: "a", href: root_url }
    ]
    scope = Noticia.includes(:caderno).published

    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      scope = scope.where(
        "LOWER(titulo) LIKE ? OR LOWER(chamada) LIKE ?", term, term
      )
    end

    ordered = scope.order(created: :desc)
    @pagy, @noticias = pagy_infinite(ordered, params[:page])

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
      mainItems:,
      secondaryItems:,
      breadcrumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Notícias", "" ],
      ),
      noticias: @noticias.as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ]
              ),
      pagy:  {
        # count: @pagy.count,
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
        # from: @pagy.from,
        # to: @pagy.to,
        # prev: @pagy.prev,
        # next: @pagy.next,
        # limit: @pagy.limit
      },
      current_url: request.path,
      searchQuery: params[:search]
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

  # TODO: Relocate this piece into a concern or helper
  def pagy_infinite(collection, page_param)
    current_page = (page_param || params[:page] || 1).to_i
    limit = Pagy::DEFAULT[:limit] || 20

    if current_page <= 1
      # First page - normal pagination
      pagy_result = pagy(collection, limit: limit)
      pagy_result
    else
      # Infinite scroll - load all items from page 1 to current page
      total_items_needed = current_page * limit

      # Get the actual items
      items = collection.limit(total_items_needed)

      # Create proper pagy object with
      # all the metadata need in the frontend
      total_count = collection.count
      pagy_obj = Pagy.new(
        count: total_count,
        limit: limit,
        page: current_page
      )

      [ pagy_obj, items ]
    end
  end
end
