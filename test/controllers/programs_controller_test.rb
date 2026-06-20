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
    assert program_sections(props).any?, "Expected at least one program section"
    assert program_sections(props).all? { _1["label"].present? }, "Expected each program section to expose a date label"
  end

  test "should return matching elements when query is provided" do
    get program_url, params: { query: "Batman" }

    assert_response :success
    props = inertia_props

    # Ensure the correct elements are returned
    elements = program_sessions(props)
    assert_equal 2, elements.length
    assert_equal [ "Batman" ], elements.map { _1["titulo"] }.uniq
  end

  test "should return all elements for 2024-10-05 when no query is provided" do
    get program_url

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert_equal 5, elements.length
  end

  test "should ignore case when searching" do
    get program_url, params: { query: "batman" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert_equal 2, elements.length
    assert_equal [ "Batman" ], elements.map { _1["titulo"] }.uniq
  end

  test "should return elements for partial title" do
    get program_url, params: { query: "ma" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length >= 2
    titles = elements.map { _1["titulo"] }
    assert_includes titles, "Amazônia Selvagem"
  end

  test "should handle special characters" do
    get program_url, params: { query: "São Paulo" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert_equal 1, elements.length
  end

  test "filters by date while preserving search query" do
    get program_url, params: { query: "Batman", date: "2024-10-05" }

    assert_response :success

    props = inertia_props
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "2024-10-05", props["current_filters"]["date"]["filter_value"]

    elements = program_sessions(props)
    elements.each do |element|
      assert_includes element["titulo"], "Batman"
      assert_equal "2024-10-05", element["data"].to_s
    end
  end

  test "elements expose dates with matching movies" do
    # 1. Search for a specific term
    get program_url, params: { query: "Batman" }

    props = inertia_props
    available_dates = program_section_labels(props)
    expected = [ "Sáb, 5 Out", "Dom, 6 Out" ]
    # 2. Verify each date actually has matching movies
    assert_equal expected, available_dates
  end

  test "handles search with no results gracefully" do
    get program_url, params: { query: "NonexistentMovie" }

    assert_response :success
    props = inertia_props

    # Should return empty arrays, not break
    assert_equal [], program_sections(props)
  end

  test "handles invalid date parameter gracefully without filtering by date" do
    get program_url, params: { query: "Batman", date: "invalid-date" }

    assert_response :success
    props = inertia_props

    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_nil props["current_filters"]["date"]
    assert program_sessions(props).all? { _1["titulo"].include?("Batman") }
  end

  test "exposes date filter options" do
    get program_url

    assert_response :success
    props = inertia_props
    dates = props["dates"]

    assert dates.is_a?(Array)
    assert_includes dates.map { _1["filter_value"] }, "2024-10-05"
    assert_equal "Data da sessão", dates.first["filter_label"]
  end

  test "filters by date and exposes current date filter" do
    get program_url, params: { date: "2024-10-06" }

    assert_response :success
    props = inertia_props

    assert_equal "2024-10-06", props["current_filters"]["date"]["filter_value"]
    assert_equal "Data da sessão", props["current_filters"]["date"]["filter_label"]

    program_sessions(props).each do |element|
      assert_equal "2024-10-06", element["data"].to_s
    end
  end

  test "combines date with search query" do
    get program_url, params: { query: "Batman", date: "2024-10-06" }

    assert_response :success
    props = inertia_props

    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "2024-10-06", props["current_filters"]["date"]["filter_value"]

    program_sessions(props).each do |element|
      assert_includes element["titulo"], "Batman"
      assert_equal "2024-10-06", element["data"].to_s
    end
  end

  test "preserves date filter when search has no results on selected date" do
    get program_url, params: { query: "Batman", date: "2024-10-07" }

    assert_response :success
    props = inertia_props

    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "2024-10-07", props["current_filters"]["date"]["filter_value"]
    assert_equal [], program_sections(props)
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
    elements = program_sessions(props)
    assert_equal 5, elements.count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
    assert_sessions_ordered_by_date_and_time(elements)
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
    elements = program_sessions(props)
    assert_equal 10, elements.count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
    assert_sessions_ordered_by_date_and_time(elements)
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
    elements = program_sessions(props)
    assert_equal 15, elements.count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
    assert_sessions_ordered_by_date_and_time(elements)
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
    elements = program_sessions(props)
    assert_equal 17, elements.count

    elements.each do |element|
      assert_includes element["titulo"], "test"
      assert_equal "2024-10-07", element["data"].to_s
    end
    assert_sessions_ordered_by_date_and_time(elements)
  end

  test "preserves search when date filter is present" do
    get program_url, params: { query: "Batman" }
    assert_response :success

    get program_url, params: { query: "Batman", date: "2024-10-06" }
    assert_response :success

    props = inertia_props
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "2024-10-06", props["current_filters"]["date"]["filter_value"]

    elements = program_sessions(props)
    elements.each do |element|
      assert_includes element["titulo"], "Batman"
      assert_equal "2024-10-06", element["data"].to_s
    end
  end

  test "exposes matching date labels when searching" do
    get program_url, params: { query: "est" }

    # 3. Assert response
    assert_response :success

    # 4. Check props
    props = inertia_props

    assert_includes program_section_labels(props), "Seg, 7 Out"
  end

  test "ignores unavailable direct date URLs with no matching movies" do
    get program_url, params: { query: "Batman", date: "2024-10-04" }

    assert_response :success
    props = inertia_props

    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal [ "Batman" ], program_sessions(props).map { _1["titulo"] }.uniq
    assert_equal [ "Sáb, 5 Out", "Dom, 6 Out" ], program_section_labels(props)
  end

  test "search exposes date labels for filtered results" do
    get program_url, params: { query: "Batman" }
    assert_response :success
    assert_equal [ "Sáb, 5 Out", "Dom, 6 Out" ], program_section_labels
  end

  test "filters by mostra - competicao nacional" do
    get program_url, params: { mostra: "competicao-nacional" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length >= 2

    elements.each do |element|
      assert_includes [ "Cidade Perdida", "Amor em Brasília" ], element["titulo"]
    end
  end

  test "filters by mostra - mostra internacional" do
    get program_url, params: { mostra: "mostra-internacional" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length >= 2

    elements.each do |element|
      assert_includes [ "Berlin Nights", "Paris Stories" ], element["titulo"]
    end
  end

  test "filters by mostra - documentarios" do
    get program_url, params: { mostra: "documentarios" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length > 1
    elements.each do |element|
      assert_includes [ "Amazônia Selvagem", "Cidade em Transformação" ], element["titulo"]
    end
  end

  test "handles invalid mostra filter gracefully" do
    get program_url, params: { mostra: "non-existent-mostra" }

    assert_response :success
    props = inertia_props

    # Should return all elements (no filter applied)
    elements = program_sessions(props)
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

    elements = program_sessions(props)
    assert elements.length >= 1
    assert_equal [ "Cidade Perdida" ], elements.map { _1["titulo"] }.uniq

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
    elements = program_sessions(props)
    assert_equal 0, elements.length

    # Filters should still be preserved
    assert_equal "Paris", props["current_filters"]["query"]["filter_value"]
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "search finds movies across different mostras" do
    get program_url, params: { query: "Cidade" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length >= 2

    titles = elements.map { |e| e["titulo"] }
    assert_includes titles, "Cidade Perdida" # from competicao-nacional
    assert_includes titles, "Cidade em Transformação" # from documentarios
  end

  test "mostra filter affects rendered date sections" do
    # Documentarios only has content on 2024-10-05, 2024-10-06 and 2024-10-07
    get program_url, params: { mostra: "documentarios" }

    assert_response :success
    props = inertia_props

    available_dates = program_section_labels(props)
    expected_dates = [ "Sáb, 5 Out", "Dom, 6 Out", "Seg, 7 Out" ]
    assert_equal expected_dates, available_dates
  end

  test "preserves mostra filter when date filter is present" do
    get program_url, params: {
      mostra: "competicao-nacional",
      date: "2024-10-06"
    }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.any?
    elements.each do |element|
      assert_equal "2024-10-06", element["data"].to_s
    end

    # Filter should be preserved
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
    assert_equal "2024-10-06", props["current_filters"]["date"]["filter_value"]
  end

  test "combines search, mostra and date" do
    get program_url, params: {
      query: "Cidade",
      mostra: "documentarios",
      date: "2024-10-07"
    }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.length >= 1
    assert_equal [ "Cidade em Transformação" ], elements.map { _1["titulo"] }.uniq
    elements.each do |element|
      assert_equal "2024-10-07", element["data"].to_s
    end

    # All filters should be preserved
    assert_equal "Cidade", props["current_filters"]["query"]["filter_value"]
    assert_equal "documentarios", props["current_filters"]["mostra"]["permalink_pt"]
    assert_equal "2024-10-07", props["current_filters"]["date"]["filter_value"]
    assert_includes program_section_labels(props), "Seg, 7 Out"
  end

  test "mostra filter with pagination" do
    get program_url, params: {
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    # Should have filtered results
    elements = program_sessions(props)
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
    assert_equal Mostra.where(edicao_id: Edicao.current.id).count, mostras_filter.length

    # Check that all mostras are included
    permalinks = mostras_filter.map { |m| m["permalink_pt"] }
    assert_includes permalinks, "competicao-nacional"
    assert_includes permalinks, "mostra-internacional"
    assert_includes permalinks, "documentarios"
    assert_includes permalinks, "premiere-brasil-longas"
    assert_includes permalinks, "premiere-brasil-curtas"

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
    elements = program_sessions(props)
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

    elements = program_sessions(props)
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
    assert program_sessions(props).length > 0

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

    elements = program_sessions(props)
    assert_equal [ "Batman" ], elements.map { _1["titulo"] }.uniq

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

    assert_equal 0, program_sessions(props).length

    # Filters preserved
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal cine_brasilia.id, props["current_filters"]["cinema"]["id"]
  end

  test "search finds movies across different cinemas" do
    get program_url, params: { query: "Cidade" }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    titles = elements.map { |e| e["titulo"] }

    assert_includes titles, "Cidade Perdida"
    assert_includes titles, "Cidade em Transformação"
  end

  test "cinema filter affects rendered date sections" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: { cinema: cine_brasilia.id }

    assert_response :success
    props = inertia_props

    available_dates = program_section_labels(props)
    assert_equal [ "Seg, 7 Out" ], available_dates.uniq
  end

  test "preserves cinema filter when date filter is present" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      cinema: cinepolis.id,
      date: "2024-10-06"
    }

    assert_response :success
    props = inertia_props

    elements = program_sessions(props)
    assert elements.any?
    elements.each do |element|
      assert_equal "2024-10-06", element["data"].to_s
    end

    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
    assert_equal "2024-10-06", props["current_filters"]["date"]["filter_value"]
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

    elements = program_sessions(props)
    assert elements.length >= 1
    elements.each do |element|
      assert_includes element["titulo"], "Cidade"
      assert_equal "2024-10-07", element["data"].to_s
    end

    assert_equal "Cidade", props["current_filters"]["query"]["filter_value"]
    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
    assert_equal "2024-10-07", props["current_filters"]["date"]["filter_value"]
    assert_includes program_section_labels(props), "Seg, 7 Out"
  end

  test "cinema filter with pagination" do
    cine_brasilia = cinemas(:cine_brasilia)
    get program_url, params: { cinema: cine_brasilia.id }

    assert_response :success
    props = inertia_props

    assert_equal 5, program_sessions(props).length
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

  test "filters session menu by special sessions only" do
    get program_url, params: { tipo_sessao: "especial", query: "Berlin", date: "2024-10-05" }

    assert_response :success
    props = inertia_props

    assert_equal "especial", props["current_session_type"]
    assert_equal "2024-10-05", props["current_filters"]["date"]["filter_value"]
    assert_equal [ "Berlin Nights" ], program_sessions(props).map { _1["titulo"] }
    assert_equal [ "Sáb, 5 Out" ], program_section_labels(props)
  end

  test "filters session menu by debate sessions only" do
    get program_url, params: { tipo_sessao: "debate", query: "Batman", date: "2024-10-05" }

    assert_response :success
    props = inertia_props

    assert_equal "debate", props["current_session_type"]
    assert_equal "2024-10-05", props["current_filters"]["date"]["filter_value"]
    assert_equal [ "Batman" ], program_sessions(props).map { _1["titulo"] }.uniq
    assert_equal [ "Sáb, 5 Out" ], program_section_labels(props)
  end

  test "filters session menu by free and limited gratuity sessions" do
    get program_url, params: { tipo_sessao: "gratuidade", date: "2024-10-05" }

    assert_response :success
    props = inertia_props

    assert_equal "gratuidade", props["current_session_type"]
    assert_equal "2024-10-05", props["current_filters"]["date"]["filter_value"]
    assert_includes program_sessions(props).map { _1["titulo"] }, "Batman"
    assert_equal [ "Sáb, 5 Out" ], program_section_labels(props)
  end

  test "programming menu context exposes session filters and one active item" do
    get program_url, params: { tipo_sessao: "debate" }

    assert_response :success
    program_menu = inertia_props["menuContext"]["programacao"]

    assert_equal [
      "Programação",
      "Sessões especiais",
      "Sessões com gratuidade",
      "Sessões com debates",
      "Mudanças na programação"
    ], program_menu.map { _1["name"] }
    assert_equal [ "Sessões com debates" ], program_menu.select { _1["active"] }.map { _1["name"] }
    assert_nil program_menu.find { _1["name"] == "Sessões com convidados" }

    assert_equal [
      program_path,
      program_path(tipo_sessao: "especial"),
      program_path(tipo_sessao: "gratuidade"),
      program_path(tipo_sessao: "debate"),
      ""
    ], program_menu.map { _1["path"] }

    program_menu.map { _1["path"] }.reject(&:blank?).each do |path|
      assert path.start_with?("/")
      refute_match %r{\Ahttps?://}, path
    end
  end

  test "programming page exposes local session type navigation" do
    get program_url, params: { tipo_sessao: "gratuidade" }

    assert_response :success
    session_type_nav = inertia_props["session_type_nav"]

    assert_equal [
      "Programação",
      "Sessões especiais",
      "Sessões com gratuidade",
      "Sessões com debates"
    ], session_type_nav.map { _1["label"] }

    assert_equal [
      nil,
      "especial",
      "gratuidade",
      "debate"
    ], session_type_nav.map { _1["session_type"] }

    assert_equal [ "Sessões com gratuidade" ], session_type_nav.select { _1["active"] }.map { _1["label"] }

    assert_equal [
      program_path,
      program_path(tipo_sessao: "especial"),
      program_path(tipo_sessao: "gratuidade"),
      program_path(tipo_sessao: "debate")
    ], session_type_nav.map { _1["href"] }

    session_type_nav.map { _1["href"] }.each do |href|
      assert href.start_with?("/")
      refute_match %r{\Ahttps?://}, href
    end
  end

  private

  def program_sections(props = inertia_props)
    props["elements"]
  end

  def program_sessions(props = inertia_props)
    program_sections(props).flat_map { _1["sessions"] }
  end

  def program_section_labels(props = inertia_props)
    program_sections(props).map { _1["label"] }
  end

  def assert_sessions_ordered_by_date_and_time(sessions)
    assert_equal sessions.sort_by { [ _1["data"], _1["sessao"].first ] }, sessions
  end
end
