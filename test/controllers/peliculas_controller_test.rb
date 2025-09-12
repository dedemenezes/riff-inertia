require "test_helper"

class PeliculasControllerTest < ActionDispatch::IntegrationTest
  test "show returns inertia response" do
    batman = peliculas(:batman)
    get pelicula_path(locale: :pt, permalink: batman.permalink)
    assert_response :success

    props = inertia_props

    assert_equal "pt", props["currentLocale"], "no locale"
    assert props["pelicula"].is_a?(Hash), "not a hash/JS Object"
    assert_equal 140, props["pelicula"]["duracao_coord_int"], "wrong duration"
    assert_equal "Christopher Nolan", props["pelicula"]["diretor_coord_int"], "wrong director"
  end
end
