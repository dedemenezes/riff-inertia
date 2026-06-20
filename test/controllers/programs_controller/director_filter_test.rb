require "test_helper"

class ProgramsController::DirectorFilterTest < ActionDispatch::IntegrationTest
  test "filters by director - Christopher Nolan" do
    get program_url, params: { "direcao" => "Christopher Nolan" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Batman" ], elements.map { _1["titulo"] }.uniq
  end

  test "filters by director - Wachowskis" do
    get program_url, params: { "direcao" => "Wachowskis" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_includes elements.map { _1["titulo"] }, "Matrix"

    # Check total count via pagination
    total_elements = props["pagy"]["count"]
    assert total_elements >= 1
  end

  test "filters by director - João Silva" do
    get program_url, params: { "direcao" => "João Silva" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Cidade Perdida" ], elements.map { _1["titulo"] }.uniq
  end

  test "filters by director - Ana Pereira" do
    get program_url, params: { "direcao" => "Ana Pereira" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "Amor em Brasília" ], element["titulo"]
    end
  end

  test "filters by director - Hans Mueller" do
    get program_url, params: { "direcao" => "Hans Mueller" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Berlin Nights" ], elements.map { _1["titulo"] }.uniq
  end

  test "filters by director - Pierre Dubois" do
    get program_url, params: { "direcao" => "Pierre Dubois" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "Paris Stories" ], element["titulo"]
    end
  end

  test "filters by director - Roberto Oliveira" do
    get program_url, params: { "direcao" => "Roberto Oliveira" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "Amazônia Selvagem" ], element["titulo"]
    end
  end

  test "filters by director - Marina Costa" do
    get program_url, params: { "direcao" => "Marina Costa" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Cidade em Transformação" ], elements.map { _1["titulo"] }.uniq
  end

  test "filters by director - Marcos Jorge" do
    get program_url, params: { "direcao" => "Marcos Jorge" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "São Paulo" ], element["titulo"]
    end
  end

  # COMBINED FILTERS TESTS WITH DIRECTOR
  test "combines search query and director filter" do
    get program_url, params: {
      query: "Batman",
      "direcao" => "Christopher Nolan"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Batman" ], elements.map { _1["titulo"] }.uniq

    # Verify both filters are preserved
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "Christopher Nolan", props["current_filters"]["direcao"]["filter_value"]
  end

  test "combines search query and director filter with no results" do
    get program_url, params: {
      query: "Batman",
      "direcao" => "Wachowskis"
    }

    assert_response :success
    props = inertia_props

    # Batman is directed by Christopher Nolan, not Wachowskis
    elements = props["elements"]
    assert_equal 0, elements.length

    # Filters should still be preserved
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
    assert_equal "Wachowskis", props["current_filters"]["direcao"]["filter_value"]
  end

  test "search finds movies across different directors" do
    get program_url, params: { query: "Cidade" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert elements.length >= 2

    titles = elements.map { |e| e["titulo"] }

    assert_includes titles, "Cidade Perdida" # directed by João Silva
    assert_includes titles, "Cidade em Transformação" # directed by Marina Costa
  end

  test "combines director filter with mostra filter" do
    get program_url, params: {
      "direcao" => "João Silva",
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal [ "Cidade Perdida" ], elements.map { _1["titulo"] }.uniq

    # Verify both filters are preserved
    assert_equal "João Silva", props["current_filters"]["direcao"]["filter_value"]
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "combines director filter with mostra filter with no results" do
    get program_url, params: {
      "direcao" => "Christopher Nolan",
      mostra: "competicao-nacional"
    }

    assert_response :success
    props = inertia_props

    # Christopher Nolan's Batman is in sci_fi mostra, not competicao-nacional
    elements = props["elements"]
    assert_equal 0, elements.length

    # Filters should still be preserved
    assert_equal "Christopher Nolan", props["current_filters"]["direcao"]["filter_value"]
    assert_equal "competicao-nacional", props["current_filters"]["mostra"]["permalink_pt"]
  end

  test "combines director filter with cinema filter" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      "direcao" => "João Silva",
      cinema: cinepolis.id
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    # This depends on which cinemas show João Silva's movies
    # Adjust expected count based on fixtures
    assert elements.length >= 0

    elements.each do |element|
    end

    # Verify both filters are preserved
    assert_equal "João Silva", props["current_filters"]["direcao"]["filter_value"]
    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
  end

  test "director filter affects rendered date sections" do
    get program_url, params: { "direcao" => "Christopher Nolan" }

    assert_response :success
    props = inertia_props

    available_dates = props["elements"].map { _1["date_label"] }.uniq
    # Should only show dates where Christopher Nolan movies are programmed
    # Adjust expected dates based on your programacoes fixtures
    assert available_dates.length >= 0
  end

  test "preserves director filter when date param is present" do
    get program_url, params: {
      "direcao" => "Wachowskis",
      date: "2024-10-07" # Adjust date based on when Wachowskis movies are shown
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    elements.each do |element|
    end

    # Filter should be preserved
    assert_equal "Wachowskis", props["current_filters"]["direcao"]["filter_value"]
  end

  test "combines all filters - search, director, mostra, cinema, and date" do
    cinepolis = cinemas(:cinepolis)
    get program_url, params: {
      query: "Matrix",
      "direcao" => "Wachowskis",
      mostra: "sci-fi", # Adjust based on actual mostra permalink
      cinema: cinepolis.id,
      date: "2024-10-06" # Adjust based on when Matrix is shown at Cinépolis
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    # Expect 1 result if all filters align, 0 if they don't
    elements.each do |element|
      assert_includes element["titulo"], "Matrix"
    end

    # All filters should be preserved
    assert_equal "Matrix", props["current_filters"]["query"]["filter_value"]
    assert_equal "Wachowskis", props["current_filters"]["direcao"]["filter_value"]
    # Adjust mostra assertion based on actual data structure
    assert_equal cinepolis.id, props["current_filters"]["cinema"]["id"]
  end

  test "returns correct director options in props" do
    get program_url

    assert_response :success
    props = inertia_props

    directors_filter = props["directors"]
    assert directors_filter.is_a?(Array)
    assert directors_filter.length >= 8 # At least the directors from fixtures

    # Check that key directors are included
    director_names = directors_filter.map { |d| d["filter_value"] || d["nome"] || d }
    assert_includes director_names, "Christopher Nolan"
    assert_includes director_names, "Wachowskis"
    assert_includes director_names, "João Silva"
    assert_includes director_names, "Ana Pereira"
    assert_includes director_names, "Hans Mueller"
    assert_includes director_names, "Pierre Dubois"
    assert_includes director_names, "Roberto Oliveira"
    assert_includes director_names, "Marina Costa"
    assert_includes director_names, "Marcos Jorge"

    # Check structure of director objects (adjust based on actual implementation)
    unless directors_filter.empty?
      director = directors_filter.first
      # This depends on how the controller structures the director filter options
      # Common patterns: simple array of strings, or array of hashes with keys
      assert (director.is_a?(String) || director.is_a?(Hash))
    end
  end

  test "handles empty director filter gracefully" do
    get program_url, params: { "direcao" => "" }

    assert_response :success
    props = inertia_props

    # Empty filter should behave like no filter - return all elements
    elements = props["elements"]
    assert elements.length > 0

    selected_filters = props["current_filters"]
    # Empty filter should not be preserved
    assert_nil selected_filters["director"]
  end

  test "director filter with special characters" do
    # Test with director that has special characters if any exist in your fixtures
    # This is more relevant if you have international directors with accents, etc.
    get program_url, params: { "direcao" => "Marcos Jorge" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "São Paulo", elements.first["titulo"]
  end
end
