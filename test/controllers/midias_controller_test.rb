require "test_helper"

class MidiasControllerTest < ActionDispatch::IntegrationTest
  test "index redirects to fotos e videos" do
    get midias_url(locale: :pt)

    assert_redirected_to midias_fotos_e_videos_path(locale: :pt)
  end

  test "fotos e videos renders media props and shared navigation paths" do
    get midias_fotos_e_videos_url(locale: :pt)

    assert_response :success
    assert_equal "Midias/FotosEVideos", inertia_component

    props = inertia_props
    assert_equal "Fotos & Vídeos", props["activePage"]
    assert_equal "Ir para Flickr do Festival", props["galleryLink"]["label"]
    assert_equal "https://www.flickr.com/photos/festivaldorio/", props["galleryLink"]["href"]
    assert_equal "Ir para YouTube do Festival", props["youtubeLink"]["label"]
    assert_equal "Troféu Redentor", props["heroPhoto"]["title"]
    assert_equal "trofeu-redentor", props["heroPhoto"]["imageKey"]
    assert_equal 2, props["videos"].length

    assert_equal(
      [
        midias_fotos_e_videos_path(locale: :pt),
        midias_impressos_path(locale: :pt)
      ],
      props["menuContext"]["midias"].map { |item| item["path"] }
    )
  end

  test "impressos renders print materials and media menu paths" do
    get midias_impressos_url(locale: :pt)

    assert_response :success
    assert_equal "Midias/Impressos", inertia_component

    props = inertia_props
    assert_equal "Impressos", props["activePage"]
    assert_equal(
      [ "Revista de programação", "Catálogo oficial", "Cartazes" ],
      props["printMaterials"].map { |material| material["title"] }
    )
    assert_equal(
      [ "revista-programacao", "catalogo-oficial", "cartazes" ],
      props["printMaterials"].map { |material| material["coverImageKey"] }
    )
    assert_empty props["printMaterials"].filter_map { |material| material["pdfUrl"] }
    assert_equal [ "image", "book" ], props["menuContext"]["midias"].map { |item| item["icon"] }
  end

  test "main navigation exposes media links" do
    get midias_impressos_url(locale: :pt)

    media_items = inertia_props["mainItems"]["Mídias"]

    assert_equal(
      [
        midias_fotos_e_videos_path(locale: :pt),
        midias_impressos_path(locale: :pt)
      ],
      media_items.map { |item| item["path"] }
    )
  end

  private

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value

    JSON.parse(data_page)["component"]
  end
end
