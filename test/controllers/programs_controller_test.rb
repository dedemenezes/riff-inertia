require "test_helper"


class ProgramsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @batman = programacoes(:program_batman)
  #   @matrix = programacoes(:program_matrix)
  # end

  test "index returns inertia response" do
    get program_url
    assert_response :success

    props = inertia_props

    assert_equal "pt", props["currentLocale"]
    assert props["available_dates"].is_a?(Array)
    assert props["elements"].any?, "Expected at least one program element"
    assert props["selected_date"].present?, "Expected selected_date to be present"
  end

  test "should return matching elements when query is provided" do
    get program_url, params: { query: "Batman" }

    assert_response :success
    props = inertia_props

    # Ensure the correct elements are returned
    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Batman", elements.first["titulo"]
  end

  test "should return all elements for 2024-10-05 when no query is provided" do
    get program_url

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 2, elements.length
  end

  test "should ignore case when searching" do
    get program_url, params: { query: "batman" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Batman", elements.first["titulo"]
  end

  test "should return elements for partial title" do
    get program_url, params: { query: "ma" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
  end

  test "should handle special characters" do
    get program_url, params: { query: "São Paulo" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
  end

  test "preserves search query when navigating to different date" do
    # 1. Make request with both query and date
    get program_url, params: { query: "Batman", date: "2024-10-05" }

    # 2. Assert response is successful
    assert_response :success

    # 3. Check that search query is preserved in props
    props = inertia_props
    assert_equal "Batman", props["searchQuery"]

    # 4. Verify results are filtered by both query AND date
    elements = props["elements"]
    elements.each do |element|
      assert_includes element["titulo"], "Batman"
      assert_equal "2024-10-05", element["data"].to_s
    end
  end

  # Write a test that verifies the search query is passed to the frontend for URL building.
  test "passes query to frontend for URL building" do
    get program_url, params: { query: "Batman" }

    # 2. Assert response is successful
    assert_response :success

    # 3. Check that search query is preserved in props
    props = inertia_props
    assert_equal "Batman", props["searchQuery"]
  end

  test "available_dates only includes dates with matching movies" do
    # 1. Search for a specific term
    get program_url, params: { query: "Batman" }

    props = inertia_props
    available_dates = props["available_dates"]
    expected = [ "2024-10-05", "2024-10-06" ]
    # 2. Verify each date actually has matching movies
    assert_equal expected, available_dates
  end

  test "handles search with no results gracefully" do
    get program_url, params: { query: "NonexistentMovie" }

    assert_response :success
    props = inertia_props

    # Should return empty arrays, not break
    assert_equal [], props["available_dates"]
    assert_equal [], props["elements"]
    assert_nil props["selected_date"]
  end

  test "handles invalid date parameter gracefully" do
    get program_url, params: { query: "Batman", date: "invalid-date" }

    assert_response :success
    props = inertia_props

    # Should fall back to first available date
    assert props["selected_date"].present?
    assert_equal "Batman", props["searchQuery"]
  end

  test "pagination returns 1st page with search and date filters" do
    get program_url, params: {
      query: "test",
      date: "2024-10-07"
    }

    assert_response :success
    props = inertia_props
    # 2. Verify pagination info
    pagy = props["pagy"]
    assert_equal 1, pagy["page"]

    # 3. Verify all results are still filtered
    elements = props["elements"]
    assert_equal 5, props["elements"].count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
  end

  test "pagination returns 2nd page with search, date and page filters" do
    get program_url, params: {
      query: "test",
      date: "2024-10-07",
      page: 2
    }

    assert_response :success
    props = inertia_props

    # 2. Verify pagination info
    pagy = props["pagy"]
    assert_equal 2, pagy["page"]

    # 3. Verify all results are still filtered
    elements = props["elements"]
    assert_equal 10, props["elements"].count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
  end
  test "pagination returns 3rd page with search, date and page filters" do
    get program_url, params: {
      query: "test",
      date: "2024-10-07",
      page: 3
    }

    assert_response :success
    props = inertia_props

    # 2. Verify pagination info
    pagy = props["pagy"]
    assert_equal 3, pagy["page"]

    # 3. Verify all results are still filtered
    elements = props["elements"]
    assert_equal 15, props["elements"].count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
  end
  test "pagination returns 4th page with search, date and page filters" do
    get program_url, params: {
      query: "test",
      date: "2024-10-07",
      page: 4
    }

    assert_response :success
    props = inertia_props

    # 2. Verify pagination info
    pagy = props["pagy"]
    assert_equal 4, pagy["page"]

    # 3. Verify all results are still filtered
    elements = props["elements"]
    assert_equal 17, props["elements"].count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
  end

  # Preserve search across dates
  test "preserves search across dates when navigating" do
    get program_url, params: { query: "Batman" }
    assert_response :success

    get program_url, params: { query: "Batman", date: "2024-10-06" }
    assert_response :success

    props = inertia_props
    assert_equal "Batman", props["searchQuery"]
    assert_includes props["selected_date"], "6 Out"

    elements = props["elements"]
    elements.each do |element|
      assert_includes element["titulo"], "Batman"
    end
  end

  test "selects first available date when searching" do
    get program_url, params: { query: "est" }

    # 3. Assert response
    assert_response :success

    # 4. Check props
    props = inertia_props

    assert_includes props["selected_date"], "7 Out"
  end
  test "handles dates with no matching movies via direct URL" do
    # User directly accesses URL with search + date that has no matches
    get program_url, params: { query: "Batman", date: "2024-10-04" }

    assert_response :success
    props = inertia_props

    # Should handle gracefully - empty results, preserved search, fallback date
    assert_equal 1, props["elements"].count
    assert_equal "Batman", props["searchQuery"]
    # Should fallback to first available date with Batman movies
    assert_not_equal "2024-10-04", props["selected_date"]
    assert_includes props["selected_date"], "5 Out"
  end

  test "search changes available dates when results are filtered" do
    # First, get all results without search to see total pages
    get program_url
    assert_response :success
    available_dates_count = inertia_props["available_dates"].count
    # total_pages_unfiltered = all_results_pagy["pages"]

    # Now search for something specific that should have fewer results
    get program_url, params: { query: "test" }
    assert_response :success
    filtered_available_dates_count = inertia_props["available_dates"].count
    # Filtered results should have fewer pages than unfiltered
    assert filtered_available_dates_count < available_dates_count,
      "Expected filtered search to have fewer dates (#{filtered_available_dates_count}) than unfiltered (#{available_dates_count})"
  end
end
