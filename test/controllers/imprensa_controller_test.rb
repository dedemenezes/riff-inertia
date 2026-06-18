require "test_helper"

class ImprensaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idioma = idiomas(:port)
  end

  test "index returns sanitized legacy html content and legacy title" do
    create_pagina(conteudo: "<p>Conteúdo de imprensa.</p><br><script>alert('xss')</script>")

    get imprensa_url(locale: :pt)

    assert_response :success
    assert_equal "Imprensa/Index", inertia_component

    props = inertia_props
    assert_equal "Imprensa", props["titulo"]
    assert_equal "<p>Conteúdo de imprensa.</p><br>", props["conteudo"]
  end

  test "index exposes imprensa in secondary navigation when content exists" do
    create_pagina

    get imprensa_url(locale: :pt)

    props = inertia_props
    press = props["secondaryItems"].find { |item| item["name"] == "Imprensa" }

    assert press, "expected Imprensa item in secondaryItems"
    assert press["internal"]
    assert_equal imprensa_path(locale: :pt), press["href"]
    assert_equal imprensa_path(locale: :pt), props["imprensaPath"]
  end

  test "english request is not found because there is no english content" do
    create_pagina

    get imprensa_url(locale: :en)

    assert_response :not_found
  end

  test "omits imprensa navigation when locale has no content" do
    create_pagina

    get talents_news_url(locale: :en)

    assert_response :success
    props = inertia_props

    assert_nil props["imprensaPath"]
    assert_not_includes props["secondaryItems"].map { |item| item["name"] }, "Press"
  end

  private

  def create_pagina(conteudo: "<p>Conteúdo de imprensa.</p>")
    Pagina.create!(
      idioma: @idioma,
      tipo: "c",
      titulo: "Imprensa",
      permalink: "contato",
      rota: "/br/imprensa/",
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
