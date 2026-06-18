require "test_helper"

class IngressosTabsTest < ActiveSupport::TestCase
  test "returns three tabs in fixed order" do
    I18n.with_locale(:pt) do
      tabs = IngressosTabs.build(active: "como_comprar")

      assert_equal 3, tabs.size
      assert_equal [ "Como comprar seu ingresso", "Pacote de ingressos", "Próximas sessões" ], tabs.map { |t| t[:label] }
    end
  end

  test "marks como comprar active when requested" do
    tabs = IngressosTabs.build(active: "como_comprar")

    assert_equal [ true, false, false ], tabs.map { |t| t[:active] }
  end

  test "marks pacotes active when requested" do
    tabs = IngressosTabs.build(active: "pacotes")

    assert_equal [ false, true, false ], tabs.map { |t| t[:active] }
  end

  test "marks proximas sessoes active when requested" do
    tabs = IngressosTabs.build(active: "proximas_sessoes")

    assert_equal [ false, false, true ], tabs.map { |t| t[:active] }
  end

  test "returns translated labels in en" do
    I18n.with_locale(:en) do
      tabs = IngressosTabs.build(active: "como_comprar")

      assert_equal [ "How to buy tickets", "Ticket packages", "Upcoming screenings" ], tabs.map { |t| t[:label] }
    end
  end

  test "tab hrefs include current locale" do
    I18n.with_locale(:pt) do
      tabs = IngressosTabs.build(active: "como_comprar")

      assert_equal "/pt/ingressos/como-comprar", tabs[0][:href]
      assert_equal "/pt/ingressos/pacotes", tabs[1][:href]
      assert_equal "/pt/ingressos/proximas-sessoes", tabs[2][:href]
    end
  end

  test "no tab active when key does not match" do
    tabs = IngressosTabs.build(active: "anything_else")

    assert tabs.none? { |t| t[:active] }
  end
end
