require "test_helper"

class JuriControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idioma = idiomas(:port)
  end

  test "index returns parsed current jury page content" do
    create_pagina(<<~HTML)
      <h3>PREMIERE BRASIL: COMPETIÇÃO PRINCIPAL</h3>
      <p><b>Eric Lagesse - Presidente do Júri</b></p>
      <p><img src="https://example.com/eric.jpg"></p>
      <p>Distribuidor, agente de vendas e produtor francês.</p>
      <script>alert("xss")</script>
      <style>.x { color: red; }</style>
    HTML

    get festival_juri_url(locale: :pt)

    assert_response :success
    assert_equal "Juri/Index", inertia_component

    props = inertia_props
    assert_equal "Júri 2025", props["titulo"]
    assert_equal "Júri", props["activePage"]
    assert_equal 1, props["sections"].size
    assert_equal "Première Brasil", props["sections"].first["tab_label"]

    juror = props["sections"].first["jurors"].first
    assert_equal "Eric Lagesse", juror["name"]
    assert_equal "Presidente do Júri", juror["role"]
    assert_equal "https://example.com/eric.jpg", juror["photo"]
    assert_equal [ "Distribuidor, agente de vendas e produtor francês." ], juror["bio"]
  end

  test "index is not found when localized current jury content does not exist" do
    create_pagina("<h3>PREMIERE BRASIL</h3>")

    get festival_juri_url(locale: :en)

    assert_response :not_found
  end

  private

  def create_pagina(conteudo)
    Pagina.create!(
      idioma: @idioma,
      tipo: "c",
      titulo: "Júri 2025",
      permalink: "juri",
      rota: "/br/o-festival/",
      conteudo: conteudo,
      ativo: true,
      created: Time.current,
      updated: Time.current
    )
  end

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value

    JSON.parse(data_page)["component"]
  end
end
