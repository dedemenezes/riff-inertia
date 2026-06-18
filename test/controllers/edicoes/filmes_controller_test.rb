require "test_helper"

class Edicoes::FilmesControllerTest < ActionDispatch::IntegrationTest
  setup { @edicao = edicoes(:edicao_12) }

  test "index renders Edicoes/Filmes with the edition's films" do
    get edicao_anterior_filmes_path(@edicao, locale: :pt)

    assert_response :success
    assert_equal "Edicoes/Filmes", inertia_component

    props = inertia_props
    assert props["elements"].is_a?(Array)
    assert props["elements"].any?, "expected films for the edition"
    assert(props["elements"].all? { |f| f["edicao_id"] == @edicao.id })
    assert_equal 9, props["elements"].length, "first page is limited to 9"
    assert_equal 1, props["pagy"]["page"]
    assert_equal @edicao.id, props["edicao"]["id"]
  end

  test "query filters films by title" do
    get edicao_anterior_filmes_path(@edicao, locale: :pt, query: "Batman")

    assert_response :success
    props = inertia_props
    assert_equal 1, props["elements"].length
    assert_equal "Batman", props["current_filters"]["query"]["filter_value"]
  end

  test "index serializes only fields used by the films listing card" do
    get edicao_anterior_filmes_path(@edicao, locale: :pt)

    film = inertia_props["elements"].first
    assert_includes film.keys, "display_titulo"
    assert_includes film.keys, "display_paises"
    assert_includes film.keys, "genre"
    assert_includes film.keys, "imageURL"
    assert_includes film.keys, "mostra_tag_class"
    assert_includes film.keys, "mostra_display_name"
    assert_includes film.keys, "duracao_coord_int"

    assert_not_includes film.keys, "programacoesAsJson"
    assert_not_includes film.keys, "banner_image"
    assert_not_includes film.keys, "carousel_images"
  end

  test "invalid page params fall back to the first page" do
    [ "0", "-1", "abc" ].each do |page|
      get edicao_anterior_filmes_path(@edicao, locale: :pt, page: page)

      assert_response :success
      assert_equal 1, inertia_props["pagy"]["page"]
    end
  end

  test "sort toggles ascending and descending by title" do
    get edicao_anterior_filmes_path(@edicao, locale: :pt, sort: "asc")
    asc = inertia_props["elements"].map { |f| f["display_titulo"] }

    get edicao_anterior_filmes_path(@edicao, locale: :pt, sort: "desc")
    desc = inertia_props["elements"].map { |f| f["display_titulo"] }

    assert_not_equal asc.first, desc.first
  end

  test "pais filter narrows results to that country" do
    get edicao_anterior_filmes_path(@edicao, locale: :pt, pais: paises(:usa).id)

    assert_response :success
    props = inertia_props
    assert_equal 3, props["elements"].length
    assert props["has_active_filters"]
  end

  test "director and actor filter options are not scoped to the edition importacao" do
    older_importacao = Importacao.create!(
      id: 2,
      edicao_id: @edicao.id,
      created: 1.day.ago
    )

    Pelicula.create!(
      importacao: older_importacao,
      edicao_id: @edicao.id,
      mostra: mostras(:sci_fi),
      permalink: "legacy-filter-option",
      titulo_portugues_coord_int: "Legacy Filter Option",
      titulo_ingles_coord_int: "Legacy Filter Option",
      titulo_original_coord_int: "Legacy Filter Option",
      diretor_coord_int: "Legacy Director",
      elenco_coord_int: "Legacy Actor",
      ativo: 1,
      created: Time.current,
      updated: Time.current
    )

    get edicao_anterior_filmes_path(@edicao, locale: :pt)

    props = inertia_props
    assert_includes props["directors"].map { |director| director["filter_value"] }, "Legacy Director"
    assert_includes props["actors"].map { |actor| actor["filter_value"] }, "Legacy Actor"
    assert(props["elements"].none? { |film| film["display_titulo"] == "Legacy Filter Option" })
  end

  private

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value
    JSON.parse(data_page)["component"]
  end
end
