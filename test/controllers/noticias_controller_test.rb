require "test_helper"

class NoticiasControllerTest < ActionDispatch::IntegrationTest
  test "filters by caderno in PT - Premio Felix" do
    get noticias_url, params: { caderno: "premio-felix" }

    assert_response :success
    props = inertia_props

    elements = props["elements"]
    assert_equal 1, elements.length

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
end
