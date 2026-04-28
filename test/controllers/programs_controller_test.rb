require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  def request_and_assert(params: {}, expected_status: :success)
    get program_url, params: params
    assert_response expected_status
    inertia_props
  end

  def assert_filter_value(props, filter_key, expected_value)
    assert_equal expected_value, props["current_filters"][filter_key]["filter_value"]
  end

  def assert_elements_match(elements, titles: nil, query: nil, date: nil, count: nil)
    assert_equal count, elements.length if count

    if titles
      actual_titles = elements.map { _1["titulo"] }
      titles.each { |title| assert_includes actual_titles, title }
    end

    if query
      elements.each { |e| assert_includes e["titulo"], query }
    end

    if date
      elements.each { |e| assert_equal date, e["data"].to_s }
    end
  end

  # Basic index tests
  test "index returns inertia response with defaults" do
    props = request_and_assert
    assert_equal "pt", props["currentLocale"]
    assert props["menuTabs"].is_a?(Array)
    assert props["elements"].any?
  end

  # Search/query tests
  test "query filters by exact title" do
    props = request_and_assert(params: { query: "Batman" })
    assert_filter_value(props, "query", "Batman")
    assert_elements_match(props["elements"], count: 1, titles: ["Batman"])
  end

  test "query is case-insensitive" do
    props = request_and_assert(params: { query: "batman" })
    assert_equal 1, props["elements"].length
    assert_equal "Batman", props["elements"].first["titulo"]
  end

  test "query matches partial titles" do
    props = request_and_assert(params: { query: "ma" })
    assert_equal 2, props["elements"].length
  end

  test "query handles special characters" do
    props = request_and_assert(params: { query: "São Paulo" })
    assert_equal 1, props["elements"].length
  end

  test "query with no results returns empty gracefully" do
    props = request_and_assert(params: { query: "NonexistentMovie" })
    assert_equal [], props["menuTabs"].map { _1["date"] }
    assert_equal [], props["elements"]
  end

  # Date + query combinations
  test "query and date together filter results" do
    props = request_and_assert(params: { query: "Batman", date: "2024-10-05" })
    assert_filter_value(props, "query", "Batman")
    assert_elements_match(props["elements"], query: "Batman", date: "2024-10-05")
  end

  test "query changes available dates menu when filtered" do
    all_dates = request_and_assert["menuTabs"].map { _1["date"] }.count
    filtered_dates = request_and_assert(params: { query: "test" })["menuTabs"].map { _1["date"] }.count
    assert filtered_dates < all_dates
  end

  test "invalid date falls back to first available" do
    props = request_and_assert(params: { query: "Batman", date: "invalid-date" })
    assert props["menuTabs"].present?
    assert_filter_value(props, "query", "Batman")
  end

  # Mostra filter tests
  mostra_filters = [
    { mostra: "competicao-nacional", expected_titles: ["Cidade Perdida", "Amor em Brasília"], count: 2 },
    { mostra: "mostra-internacional", expected_titles: ["Berlin Nights", "Paris Stories"], count: 2 },
    { mostra: "documentarios", expected_titles: ["Amazônia Selvagem", "Cidade em Transformação"], count: 1 }
  ]

  mostra_filters.each do |filter|
    test "filters by mostra - #{filter[:mostra]}" do
      props = request_and_assert(params: { mostra: filter[:mostra] })
      assert_elements_match(props["elements"], titles: filter[:expected_titles], count: filter[:count])
    end
  end

  test "invalid mostra ignored and returns all elements" do
    props = request_and_assert(params: { mostra: "non-existent" })
    assert props["elements"].length > 0
    assert_nil props["current_filters"]["mostra"]
  end

  test "mostra with query - only matching results" do
    props = request_and_assert(params: { query: "Cidade", mostra: "competicao-nacional" })
    assert_elements_match(props["elements"], count: 1, titles: ["Cidade Perdida"])
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "mostra with query - no cross-mostra matches" do
    props = request_and_assert(params: { query: "Paris", mostra: "competicao-nacional" })
    assert_equal 0, props["elements"].length
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "mostra filter affects available dates" do
    props = request_and_assert(params: { mostra: "documentarios" })
    available_dates = props["menuTabs"].map { _1["date"] }
    assert_equal ["Sáb, 5 Out", "Dom, 6 Out", "Seg, 7 Out"], available_dates
  end

  # Cinema filter tests
  test "filters by cinema cine_brasilia" do
    cine = cinemas(:cine_brasilia)
    props = request_and_assert(params: { cinema: cine.id })
    assert_equal 5, props["elements"].length
    assert_equal 17, props["pagy"]["count"]
  end

  test "filters by cinema cinepolis" do
    cinema = cinemas(:cinepolis)
    props = request_and_assert(params: { cinema: cinema.id })
    expected = ["Cidade Perdida", "Cidade em Transformação", "Amor em Brasília", "Berlin Nights", "São Paulo"]
    actual_titles = props["elements"].map { _1["titulo"] }
    expected.each { |title| assert_includes actual_titles, title }
  end

  test "invalid cinema ignored" do
    props = request_and_assert(params: { cinema: 999_999 })
    assert props["elements"].length > 0
    assert_nil props["current_filters"]["cinema"]
  end

  test "cinema with query" do
    cinema = cinemas(:cinepolis)
    props = request_and_assert(params: { query: "Batman", cinema: cinema.id })
    assert_elements_match(props["elements"], count: 1, titles: ["Batman"])
    assert_equal cinema.id, props["current_filters"]["cinema"]["id"]
  end

  test "cinema with query - no results" do
    cinema = cinemas(:cine_brasilia)
    props = request_and_assert(params: { query: "Batman", cinema: cinema.id })
    assert_equal 0, props["elements"].length
  end

  test "cinema filter affects available dates" do
    cinema = cinemas(:cine_brasilia)
    props = request_and_assert(params: { cinema: cinema.id })
    available_dates = props["menuTabs"].map { _1["date"] }
    assert_equal ["Seg, 7 Out"], available_dates.uniq
  end

  # Pagination tests
  pagination_tests = [
    { page: 1, query: "test", date: "2024-10-07", expected_count: 5 },
    { page: 2, query: "test", date: "2024-10-07", expected_count: 10 },
    { page: 3, query: "test", date: "2024-10-07", expected_count: 15 },
    { page: 4, query: "test", date: "2024-10-07", expected_count: 17 }
  ]

  pagination_tests.each do |test_case|
    test "pagination page #{test_case[:page]} with filters" do
      params = { query: test_case[:query], date: test_case[:date], page: test_case[:page] }
      props = request_and_assert(params: params)

      assert_equal test_case[:page], props["pagy"]["page"]
      assert_equal test_case[:expected_count], props["elements"].count
      assert_elements_match(props["elements"], query: "test", date: "2024-10-07")
    end
  end

  # Props/structure tests
  test "mostras filter options in props" do
    props = request_and_assert
    mostras = props["mostras"]
    assert_equal 4, mostras.length

    permalinks = mostras.map { |m| m["permalink_pt"] }
    %w[competicao-nacional mostra-internacional documentarios].each do |name|
      assert_includes permalinks, name
    end

    mostra = mostras.first
    assert mostra["id"].present?
    assert mostra["permalink_pt"].present?
    assert mostra["nome_abreviado"].present?
  end

  test "cinemas filter options in props" do
    props = request_and_assert
    cinemas_list = props["cinemas"]
    assert_equal 2, cinemas_list.length

    names = cinemas_list.map { _1["nome"] }
    %w[Cinépolis\ Lagoon Cine\ Brasília].each { |name| assert_includes names, name }

    cinema = cinemas_list.first
    assert cinema["id"].present?
    assert cinema["nome"].present?
  end
end
