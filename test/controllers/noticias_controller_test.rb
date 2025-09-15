require "test_helper"

class NoticiasControllerTest < ActionDispatch::IntegrationTest
  test "index returns inertia response with default locale and data" do
    get noticias_url

    assert_response :success
    props = inertia_props

    assert_equal "pt", props["currentLocale"]
    assert props["elements"].is_a?(Array), "Expected elements to be an array"
    assert props["elements"].any?, "Expected at least one element"
  end

  test "returns correct cadernos options in props" do
    get noticias_url(locale: :pt)

    assert_response :success
    props = inertia_props

    cadernos_filter = props["cadernos"]

    assert_equal 2, cadernos_filter.length

    # Check that all mostras are included
    filter_values = cadernos_filter.map { |c| c["filter_value"] }
    assert_includes filter_values, "talents-rio"
    assert_includes filter_values, "premio-felix"

    # Check structure of mostra objects
    mostra = cadernos_filter.first
    assert mostra["filter_value"].present?
    assert mostra["filter_label"].present?
    assert mostra["filter_display"].present?
  end

  test "filters by invalid caderno handles failure gracefully" do
    get noticias_url, params: { caderno: "non-existing" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 0, elements.length
    assert_nil props["current_filters"]["caderno"]
  end

  test "filters by caderno in PT - Premio Felix" do
    get noticias_url, params: { caderno: "premio-felix" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    assert_equal "premio-felix", props["current_filters"]["caderno"]["filter_value"]
    elements.each do |element|
      assert_includes [ "TEST FELIX TWO titulo" ], element["titulo"]
    end
  end
  test "filters by caderno in EN - Felix Award" do
    get noticias_url(locale: :en), params: { caderno: "felix-award" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "TEST FELIX TWO titulo" ], element["titulo"]
    end
  end

  test "filters by date - 2025-08-05 - returns all" do
    get noticias_url(locale: :en), params: { data: "2025-08-05" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 2, elements.length

    assert_equal "2025-08-05", props["current_filters"]["data"]["filter_value"]

    elements.each do |element|
      assert_includes [ "TEST TALENTS ONE titulo", "TEST FELIX TWO titulo" ], element["titulo"]
    end
  end

  test "filters by date in PT - 2025-08-11 returns only one" do
    get noticias_url(locale: :en), params: { data: "2025-08-11" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

    elements.each do |element|
      assert_includes [ "TEST FELIX TWO titulo" ], element["titulo"]
    end

    assert_equal "2025-08-11", props["current_filters"]["data"]["filter_value"]
  end

  def test_combines_date_and_caderno_filter_in_pt
    caderno = cadernos(:felix)
    get noticias_url, params: {
      data: "2025-08-11",
      caderno: caderno.permalink_pt
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "TEST FELIX TWO titulo", elements.first["titulo"]

    # Filters preserved
    assert_equal "2025-08-11", props["current_filters"]["data"]["filter_value"]
    assert_equal caderno.permalink_pt, props["current_filters"]["caderno"]["filter_value"]
  end

  def test_combines_date_and_caderno_filter_in_en
    caderno = cadernos(:felix)
    get noticias_url(locale: :en), params: {
      data: "2025-08-11",
      caderno: caderno.permalink_en
    }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length
    assert_equal "TEST FELIX TWO titulo", elements.first["titulo"]

    # Filters preserved
    assert_equal "2025-08-11", props["current_filters"]["data"]["filter_value"]
    assert_equal caderno.permalink_en, props["current_filters"]["caderno"]["filter_value"]
  end
end
