require "test_helper"

class MostrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @premiere_longas = mostras(:premiere_brasil_longas)
    @sci_fi = mostras(:sci_fi)
    @abertura_2023 = mostras(:noite_abertura_2023)
  end

  test "show resolves by permalink and responds with success" do
    get mostra_path(@sci_fi, locale: :pt)

    assert_response :success
    assert_equal "Mostras/Show", inertia_component
  end

  test "show groups premiere brasil submostras for the current edition" do
    get mostra_path(@premiere_longas, locale: :pt)

    assert_response :success
    props = inertia_props
    assert_equal "Première Brasil", props["categoria"]
    assert_equal 2, props["mostras"].length
    assert_includes props["mostras"].map { |mostra| mostra["nome_abreviado"] }, @premiere_longas.nome_abreviado
    assert_includes props["mostras"].map { |mostra| mostra["nome_abreviado"] }, mostras(:premiere_brasil_curtas).nome_abreviado
  end

  test "show returns only films from a single mostra category" do
    get mostra_path(@sci_fi, locale: :pt)

    titles = inertia_props["elements"].map { |film| film["display_titulo"] }
    assert_includes titles, "Batman"
    assert_not_includes titles, "Filme Première Longa"
  end

  test "show does not resolve previous edition permalinks in the global current-edition route" do
    get mostra_path(@abertura_2023, locale: :pt)

    assert_response :not_found
  end

  test "show returns not found for unknown permalink" do
    get mostra_path("unknown-mostra", locale: :pt)

    assert_response :not_found
  end

  test "index links categories by permalink instead of display name" do
    get mostras_path(locale: :pt)

    assert_response :success
    sci_fi_path = inertia_props["categorias"].find { |categoria| categoria["name"] == @sci_fi.display_name }["path"]
    assert_includes sci_fi_path, @sci_fi.permalink_pt
    assert_not_includes sci_fi_path, @sci_fi.display_name
  end

  private

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value
    JSON.parse(data_page)["component"]
  end
end
