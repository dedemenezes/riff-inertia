require "test_helper"

class PeliculasControllerTest < ActionDispatch::IntegrationTest
  test "index serializes card payload with responsive image data" do
    get peliculas_path(locale: :pt)

    assert_response :success

    film = inertia_props["elements"].first
    assert_includes film.keys, "display_titulo"
    assert_includes film.keys, "display_paises"
    assert_includes film.keys, "genre"
    assert_includes film.keys, "card_image"
    assert_includes film.keys, "mostra_tag_class"
    assert_includes film.keys, "mostra_display_name"
    assert_includes film.keys, "duracao_coord_int"

    assert_card_image_uses_listing_variant(film["card_image"])
    assert_not_includes film.keys, "imageURL"
    assert_not_includes film.keys, "programacoesAsJson"
    assert_not_includes film.keys, "banner_image"
    assert_not_includes film.keys, "carousel_images"
  end

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

  private

  def assert_card_image_uses_listing_variant(card_image)
    assert_equal "(min-width: 1024px) 33vw, (min-width: 768px) 50vw, 100vw", card_image["sizes"]
    assert_includes card_image["src"], "/medium2/"
    assert_includes card_image["srcset"], "/medium/"
    assert_includes card_image["srcset"], "/medium2/"
    assert_includes card_image["srcset"], "/large/"
    refute_includes card_image["src"], "/original/"
    refute_includes card_image["srcset"], "/original/"
  end
end
