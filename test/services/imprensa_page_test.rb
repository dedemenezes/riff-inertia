require "test_helper"

class ImprensaPageTest < ActiveSupport::TestCase
  setup do
    @idioma = idiomas(:port)
  end

  test "returns the portuguese imprensa page" do
    pagina = create_pagina

    assert_equal pagina, ImprensaPage.for(:pt)
  end

  test "returns nil for english because there is no localized content" do
    create_pagina

    assert_nil ImprensaPage.for(:en)
  end

  test "returns nil when there is no imprensa page" do
    assert_nil ImprensaPage.for(:pt)
  end

  test "returns nil when locale is nil" do
    create_pagina

    assert_nil ImprensaPage.for(nil)
  end

  private

  def create_pagina
    Pagina.create!(
      idioma: @idioma,
      tipo: "c",
      titulo: "Imprensa",
      permalink: "contato",
      rota: "/br/imprensa/",
      conteudo: "<p>Conteúdo de imprensa.</p>",
      ativo: true,
      created: Time.current,
      updated: Time.current
    )
  end
end
