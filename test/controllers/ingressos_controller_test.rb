require "test_helper"

class IngressosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idioma = idiomas(:port)
    create_pagina(
      titulo: "Como comprar seu ingresso",
      permalink: "como-e-onde-comprar",
      conteudo: "<p>Conteúdo de como comprar.</p><script>alert('xss')</script>"
    )
    create_pagina(
      titulo: "Pacote de Ingressos",
      permalink: "pacotes",
      conteudo: "<p>Conteúdo dos pacotes.</p>"
    )
  end

  test "index redirects to como comprar" do
    get ingressos_url(locale: :pt)

    assert_redirected_to ingressos_como_comprar_path(locale: :pt)
  end

  test "como comprar returns legacy html content and active tab" do
    get ingressos_como_comprar_url(locale: :pt)

    assert_response :success
    assert_equal "Ingressos/Conteudo", inertia_component

    props = inertia_props
    assert_equal "Como comprar seu ingresso", props["titulo"]
    assert_equal "<p>Conteúdo de como comprar.</p>", props["conteudo"]
    assert_equal [ "Como comprar seu ingresso" ], active_tab_labels(props)
  end

  test "pacotes returns legacy html content and active tab" do
    get ingressos_pacotes_url(locale: :pt)

    assert_response :success
    assert_equal "Ingressos/Conteudo", inertia_component

    props = inertia_props
    assert_equal "Pacote de Ingressos", props["titulo"]
    assert_equal "<p>Conteúdo dos pacotes.</p>", props["conteudo"]
    assert_equal [ "Pacote de ingressos" ], active_tab_labels(props)
  end

  test "proximas sessoes returns programacao link and active tab" do
    get ingressos_proximas_sessoes_url(locale: :pt)

    assert_response :success
    assert_equal "Ingressos/ProximasSessoes", inertia_component

    props = inertia_props
    assert_equal "Próximas sessões", props["titulo"]
    assert_equal "Ver programação", props["cta"]
    assert_equal program_path(locale: :pt), props["programPath"]
    assert_equal [ "Próximas sessões" ], active_tab_labels(props)
  end

  test "uses fallback portuguese legacy content when localized english page does not exist" do
    get ingressos_como_comprar_url(locale: :en)

    assert_response :success

    props = inertia_props
    assert_equal "Como comprar seu ingresso", props["titulo"]
    assert_equal "<p>Conteúdo de como comprar.</p>", props["conteudo"]
    assert_equal [ "How to buy tickets", "Ticket packages", "Upcoming screenings" ], props["tabs"].map { |tab| tab["label"] }
  end

  private

  def create_pagina(titulo:, permalink:, conteudo:)
    Pagina.create!(
      idioma: @idioma,
      tipo: "P",
      titulo: titulo,
      permalink: permalink,
      rota: "/br/ingressos/",
      conteudo: conteudo,
      ativo: true,
      created: Time.current,
      updated: Time.current
    )
  end

  def active_tab_labels(props)
    props["tabs"].select { |tab| tab["active"] }.map { |tab| tab["label"] }
  end

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value

    JSON.parse(data_page)["component"]
  end
end
