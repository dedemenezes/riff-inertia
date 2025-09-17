module InfiniteScrollable
  extend ActiveSupport::Concern

  def pagy_infinite(collection, page_param, limit = 5)
    current_page = (page_param || params[:page] || 1).to_i
    limit = limit || Pagy::DEFAULT[:limit]

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
