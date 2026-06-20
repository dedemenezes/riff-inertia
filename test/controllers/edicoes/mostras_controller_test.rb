require "test_helper"

class Edicoes::MostrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edicao_12 = edicoes(:edicao_12)
    @edicao_13 = edicoes(:edicao_13)
    @edicao_14 = edicoes(:edicao_14)
    @premiere_longas = mostras(:premiere_brasil_longas)
    @abertura_2023 = mostras(:noite_abertura_2023)
  end

  test "premiere_brasil renders the historical page with premiere films only" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt)

    assert_response :success
    assert_equal "Edicoes/Mostras/Show", inertia_component

    props = inertia_props
    titles = props["elements"].map { |film| film["display_titulo"] }
    assert_includes titles, "Filme Première Longa"
    assert_includes titles, "Filme Première Curta"
    assert_not_includes titles, "Batman"
  end

  test "premiere_brasil does not mix films from other editions" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt)

    titles = inertia_props["elements"].map { |film| film["display_titulo"] }
    assert_not_includes titles, "Filme Abertura 2023"
  end

  test "premiere_brasil returns not found when the edition has no premiere brasil" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_14, locale: :pt)

    assert_response :not_found
  end

  test "premiere_brasil returns not found for unknown edition" do
    get edicao_anterior_mostras_premiere_brasil_path(999, locale: :pt)

    assert_response :not_found
  end

  test "premiere_brasil submostras filter lists only premiere submostras" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt)

    submostra_names = inertia_props["submostras"].map { |mostra| mostra["nome_abreviado"] }
    assert_equal 2, submostra_names.length
    assert_includes submostra_names, @premiere_longas.nome_abreviado
    assert_includes submostra_names, mostras(:premiere_brasil_curtas).nome_abreviado
    assert_not_includes submostra_names, mostras(:sci_fi).nome_abreviado
  end

  test "premiere_brasil serializes a slim non-clickable film payload" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt)

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
    assert_not_includes film.keys, "url"
  end

  test "premiere_brasil uses the special route as tab base url and paginates nine films" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt)

    props = inertia_props
    assert_equal edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt), props["tabBaseUrl"]
    assert_equal 1, props["pagy"]["page"]
    assert_operator props["elements"].length, :<=, 9
  end

  test "premiere_brasil sanitizes invalid page params" do
    get edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt), params: { page: 0 }

    assert_equal 1, inertia_props["pagy"]["page"]
  end

  test "show renders a non-premiere historical mostra inside previous-edition context" do
    get edicao_anterior_mostra_path(@edicao_13, @abertura_2023, locale: :pt)

    assert_response :success
    assert_equal "Edicoes/Mostras/Show", inertia_component

    props = inertia_props
    assert_equal "Noite de Abertura", props["categoria"]
    assert_equal edicao_anterior_mostra_path(@edicao_13, @abertura_2023, locale: :pt), props["tabBaseUrl"]
    assert_equal 1, props["mostras"].length
    assert_equal @abertura_2023.nome_abreviado, props["mostras"].first["nome_abreviado"]

    titles = props["elements"].map { |film| film["display_titulo"] }
    assert_equal [ "Filme Abertura 2023" ], titles
  end

  test "show returns not found when permalink is not in the previous edition latest importacao" do
    get edicao_anterior_mostra_path(@edicao_12, @abertura_2023, locale: :pt)

    assert_response :not_found
  end

  test "index links premiere brasil to the special route and other mostras to nested historical routes" do
    get edicao_anterior_mostras_path(@edicao_12, locale: :pt)

    categorias = inertia_props["categorias"]
    premiere_path = categorias.find { |categoria| categoria["name"] == @premiere_longas.display_name }["path"]
    sci_fi_path = categorias.find { |categoria| categoria["name"] == mostras(:sci_fi).display_name }["path"]

    assert_equal edicao_anterior_mostras_premiere_brasil_path(@edicao_12, locale: :pt), premiere_path
    assert_equal edicao_anterior_mostra_path(@edicao_12, mostras(:sci_fi), locale: :pt), sci_fi_path
  end

  test "index links non-premiere previous edition mostras by nested permalink" do
    get edicao_anterior_mostras_path(@edicao_13, locale: :pt)

    path = inertia_props["categorias"].first["path"]
    assert_equal edicao_anterior_mostra_path(@edicao_13, @abertura_2023, locale: :pt), path
  end

  private

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value
    JSON.parse(data_page)["component"]
  end
end
