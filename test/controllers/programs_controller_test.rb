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

    assert_equal "pt", props["currentLocale"], "no locale"
    assert props["menuTabs"].is_a?(Array), "not an array"
    assert props["elements"].any?, "Expected at least one program element"
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
    assert_equal 5, elements.length
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
    assert_equal 2, elements.length
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
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]

    # 4. Verify results are filtered by both query AND date
    elements = props["elements"]
    elements.each do |element|
      assert_includes element["titulo"], "Batman"
      assert_equal "2024-10-05", element["data"].to_s
    end
  end

  test "menuTabs only includes dates with matching movies" do
    # 1. Search for a specific term
    get program_url, params: { query: "Batman" }

    props = inertia_props
    available_dates = props["menuTabs"].map { _1["date"] }
    expected = [ "2024-10-05", "2024-10-06" ]
    # 2. Verify each date actually has matching movies
    assert_equal expected, available_dates
  end

  test "handles search with no results gracefully" do
    get program_url, params: { query: "NonexistentMovie" }

    assert_response :success
    props = inertia_props

    # Should return empty arrays, not break
    assert_equal [], props["menuTabs"].map { _1["date"] }
    assert_equal [], props["elements"]
    # assert_equal "", props["menuTabs"].map { _1["date"] }
  end

  test "handles invalid date parameter gracefully" do
    get program_url, params: { query: "Batman", date: "invalid-date" }

    assert_response :success
    props = inertia_props

    # Should fall back to first available date
    assert props["menuTabs"].present?
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
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
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_includes props["menuTabs"].map { _1["date"] }, "2024-10-06"

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

    assert_includes props["menuTabs"].map { _1["date"] }, "2024-10-07"
  end
  test "handles dates with no matching movies via direct URL" do
    # User directly accesses URL with search + date that has no matches
    get program_url, params: { query: "Batman", date: "2024-10-04" }

    assert_response :success
    props = inertia_props

    # Should handle gracefully - empty results, preserved search, fallback date
    assert_equal 1, props["elements"].count
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    # Should fallback to first available date with Batman movies
    assert_not_equal "2024-10-04", props["menuTabs"].map { _1["date"] }
    assert_includes props["menuTabs"].map { _1["date"] }, "2024-10-05"
  end

  test "search changes available dates when results are filtered" do
    # First, get all results without search to see total pages
    get program_url
    assert_response :success
    available_dates_count = inertia_props["menuTabs"].map { _1["date"] }.count
    # total_pages_unfiltered = all_results_pagy["pages"]

    # Now search for something specific that should have fewer results
    get program_url, params: { query: "test" }
    assert_response :success
    filtered_available_dates_count = inertia_props["menuTabs"].map { _1["date"] }.count
    # Filtered results should have fewer pages than unfiltered
    assert filtered_available_dates_count < available_dates_count,
      "Expected filtered search to have fewer dates (#{filtered_available_dates_count}) than unfiltered (#{available_dates_count})"
  end

  test "filters by mostra - competicao nacional" do
    get program_url, params: { mostra: "competicao-nacional" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 2, elements.length

    elements.each do |element|
      assert_includes [ "Cidade Perdida", "Amor em Brasília" ], element["titulo"]
    end
  end

  test "filters by mostra - mostra internacional" do
    get program_url, params: { mostra: "mostra-internacional" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 2, elements.length

    elements.each do |element|
      assert_includes [ "Berlin Nights", "Paris Stories" ], element["titulo"]
    end
  end

  test "filters by mostra - documentarios" do
    get program_url, params: { mostra: "documentarios" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    # Only 1 element on first available date (2024-10-05)
    assert_equal 1, elements.length
    elements.each do |element|
      assert_includes [ "Amazônia Selvagem", "Cidade em Transformação" ], element["titulo"]
    end
  end

  test "handles invalid mostra filter gracefully" do
    get program_url, params: { mostra: "non-existent-mostra" }

    assert_response :success
    props = inertia_props

    # Should return all elements (no filter applied)
    elements = props["elements"]
    assert elements.length > 0

    # selectedFilters should be empty
    selected_filters = props["current_filters"]
    assert_nil selected_filters["mostra"]
  end

  # COMBINED FILTERS TESTS
  test "combines search query and mostra filter" do
    get program_url, params: {
      query: "Cidade",
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Cidade Perdida", elements.first["titulo"]

    # Verify both filters are preserved
    assert_equal "Cidade", props["current_filters"]["query"]["filter_value"]
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "combines search query and mostra filter with no results" do
    get program_url, params: {
      query: "Paris",
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    # Paris is in internacional mostra, not competicao-nacional
    elements = props["elements"]
    assert_equal 0, elements.length

    # Filters should still be preserved
    assert_equal "Paris", props["current_filters"]["query"]["filter_value"]
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "search finds movies across different mostras" do
    get program_url, params: { query: "Cidade" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 2, elements.length

    titles = elements.map { |e| e["titulo"] }
    assert_includes titles, "Cidade Perdida" # from competicao-nacional
    assert_includes titles, "Cidade em Transformação" # from documentarios
  end

  test "mostra filter affects available dates" do
    # Documentarios only has content on 2024-10-05, 2024-10-06 and 2024-10-07
    get program_url, params: { mostra: "documentarios" }

    assert_response :success
    props = inertia_props

    available_dates = props["menuTabs"].map { _1["date"] }
    expected_dates = [ "2024-10-05", "2024-10-06", "2024-10-07" ]
    assert_equal expected_dates, available_dates
  end

  test "preserves mostra filter when navigating dates" do
    get program_url, params: {
      mostra: "competicao-nacional",
      date: "2024-10-06"
    }

    assert_response :success
    props = inertia_props

    # Should show nacional movie on 2024-10-06
    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Cidade Perdida", elements.first["titulo"]

    # Filter should be preserved
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "combines all filters - search, mostra, and date" do
    get program_url, params: {
      query: "Cidade",
      mostra: "documentarios",
      date: "2024-10-07"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Cidade em Transformação", elements.first["titulo"]

    # All filters should be preserved
    assert_equal "Cidade", props["current_filters"]["query"]["filter_value"]
    assert_equal "documentarios", props["current_filters"]["mostra"]["permalink_pt"]
    assert_includes props["menuTabs"].map { _1["date"] }, "2024-10-07"
  end

  test "mostra filter with pagination" do
    get program_url, params: {
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    # Should have filtered results
    elements = props["elements"]
    assert elements.length > 0

    elements.each do |element|
      assert_includes [ "Cidade Perdida", "Amor em Brasília" ], element["titulo"]
    end

    # Pagination should work
    pagy = props["pagy"]
    assert_equal 1, pagy["page"]
  end

  test "returns correct mostras options in props" do
    get program_url

    assert_response :success
    props = inertia_props

    mostras_filter = props["mostras"]
    assert_equal 4, mostras_filter.length

    # Check that all mostras are included
    permalinks = mostras_filter.map { |m| m["permalink_pt"] }
    assert_includes permalinks, "competicao-nacional"
    assert_includes permalinks, "mostra-internacional"
    assert_includes permalinks, "documentarios"

    # Check structure of mostra objects
    mostra = mostras_filter.first
    assert mostra["id"].present?
    assert mostra["permalink_pt"].present?
    assert mostra["nome_abreviado"].present?
  end

  test "provides correct cinemas filters options" do
    get program_url
    assert_response :success
    props = inertia_props
    cinema_options = props["cinemas"]
    assert_equal 2, cinema_options.length
  end

  test "filters by cinema - cine brasilia" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: { cinema: cine_brasilia.id }

    assert_response :success
    props = inertia_props

    # 17 total only 5 first page
    elements = props["elements"]
    assert_equal 5, elements.length
    # 17 total so 5 pages
    total_elements = props["pagy"]["count"]
    assert_equal 17, total_elements
  end
  test "filters by cinema - cinepolis" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: { cinema: cinepolis.id }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    titles = elements.map { |e| e["titulo"] }

    # Movies associated with cinepolis only
    expected_titles = [ "Cidade Perdida", "Cidade em Transformação", "Amor em Brasília", "Berlin Nights", "São Paulo" ]
    expected_titles.each { |title| assert_includes titles, title }
  end

  test "handles invalid cinema filter gracefully" do
    get program_url, params: { cinema: 999_999 }

    assert_response :success
    props = inertia_props

    # Should fallback to all movies (no filter)
    assert props["elements"].length > 0

    selected_filters = props["current_filters"]
    assert_nil selected_filters["cinema"]
  end

  test "combines search query and cinema filter" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      query: "Batman",
      cinema: cinepolis.id
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Batman", elements.first["titulo"]

    # Filters preserved
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
  end

  test "combines search query and cinema filter with no results" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: {
      query: "Batman",
      cinema: cine_brasilia.id
    }

    assert_response :success
    props = inertia_props

    assert_equal 0, props["elements"].length

    # Filters preserved
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal cine_brasilia.id, props["current_filters"]["cinema"]["id"]
  end

  test "search finds movies across different cinemas" do
    get program_url, params: { query: "Cidade" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    titles = elements.map { |e| e["titulo"] }

    assert_includes titles, "Cidade Perdida"
    assert_includes titles, "Cidade em Transformação"
  end

  test "cinema filter affects available dates" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: { cinema: cine_brasilia.id }

    assert_response :success
    props = inertia_props

    available_dates = props["menuTabs"].map { _1["date"] }
    assert_equal [ "2024-10-07" ], available_dates.uniq
  end

  test "preserves cinema filter when navigating dates" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      cinema: cinepolis.id,
      date: "2024-10-06"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    titles = elements.map { |e| e["titulo"] }
    assert_includes titles, "Amazônia Selvagem"
    assert_includes titles, "Matrix"

    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
  end

  test "combines all filters - search, cinema, and date" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      query: "Cidade",
      cinema: cinepolis.id,
      date: "2024-10-07"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "Cidade em Transformação", elements.first["titulo"]

    assert_equal "Cidade", props["current_filters"]["query"]["filter_value"]
    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
    assert_includes props["menuTabs"].map { _1["date"] }, "2024-10-07"
  end

  test "cinema filter with pagination" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: { cinema: cine_brasilia.id }

    assert_response :success
    props = inertia_props

    assert_equal 5, props["elements"].length
    assert_equal 1, props["pagy"]["page"]
    assert_equal 17, props["pagy"]["count"]
  end

  test "returns correct cinemas options in props" do
    get program_url

    assert_response :success
    props = inertia_props

    cinemas_filter = props["cinemas"]
    assert_equal 2, cinemas_filter.length

    names = cinemas_filter.map { _1["nome"] }
    assert_includes names, "Cinépolis Lagoon"
    assert_includes names, "Cine Brasília"

    # Ensure structure
    cinema = cinemas_filter.first
    assert cinema["id"].present?
    assert cinema["nome"].present?
  end
end
