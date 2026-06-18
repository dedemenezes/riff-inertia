require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home renders without error" do
    HTTParty.stub(:get, { "items" => [] }) do
      get root_path(locale: :pt)
    end

    assert_response :success

    props = inertia_props
    assert_equal "pt", props["currentLocale"]
    assert props["webdoors"].is_a?(Array), "Expected webdoors to be an array"
    assert props["noticias"].is_a?(Array), "Expected noticias to be an array"
  end
end
