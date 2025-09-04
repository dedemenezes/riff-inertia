class NoticiasController < ApplicationController
  include BreadcrumbsHelper
  include Pagy::Backend

  def index
    scope = Noticia.includes(:caderno)

    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      scope = scope.where(
        "LOWER(titulo) LIKE ? OR LOWER(chamada) LIKE ?", term, term
      )
    end

    ordered = scope.order(created: :desc)
    @pagy, @noticias = pagy_infinite(ordered, params[:page])
    puts "================="
    puts @noticias.count
    sleep(3)
    puts "================="

    render inertia: "Noticias/Index", props: {
      rootUrl: @root_url,
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

  def pagy_infinite(collection, page_param)
    current_page = (page_param || params[:page] || 1).to_i
    limit = Pagy::DEFAULT[:limit] || 20

    puts "=== PAGY_INFINITE DEBUG ==="
    puts "current_page: #{current_page}"
    puts "limit: #{limit}"
    puts "collection.count: #{collection.count}"
    if current_page <= 1
      # First page - normal pagination
      puts "Loading first page normally"
      pagy_result = pagy(collection, limit: limit)
      puts "First page result: #{pagy_result[1].count} items"
      pagy_result
    else
      # Infinite scroll - load all items from page 1 to current page
      total_items_needed = current_page * limit
      puts "Need total items: #{total_items_needed}"

      # Get the actual items
      items = collection.limit(total_items_needed)
      puts "Actually loaded: #{items.count} items"

      # Create proper pagy object with all the metadata
      total_count = collection.count
      pagy_obj = Pagy.new(
        count: total_count,
        limit: limit,
        page: current_page
      )

      puts "Pagy object - page: #{pagy_obj.page}, limit: #{pagy_obj.limit}, last: #{pagy_obj.last}"
      puts "========================="

      [ pagy_obj, items ]
    end

    # page ||= 1
    # if page.present? && page.to_i > 1
    #   total_items = page.to_i * Pagy::DEFAULT[:limit]
    #   pagy_items = collection.limit(total_items)
    #   pagy_obj = Pagy.new(count: collection.count, page:)
    #   binding.pry
    #   return [ pagy_obj, pagy_items ]
    # end
    # pagy(collection)
  end
end
