require "test_helper"

class TalentsTabsTest < ActiveSupport::TestCase
  test "returns three tabs in fixed order" do
    tabs = TalentsTabs.build(active: "sobre")

    assert_equal 3, tabs.size
    assert_equal [ true, false, false ], tabs.map { |t| t[:active] }
  end

  test "marks notícias active when requested" do
    tabs = TalentsTabs.build(active: "noticias_e_criticas")

    assert_equal [ false, true, false ], tabs.map { |t| t[:active] }
  end

  test "marks programação active when requested" do
    tabs = TalentsTabs.build(active: "programacao")

    assert_equal [ false, false, true ], tabs.map { |t| t[:active] }
  end

  test "no tab active when key does not match" do
    tabs = TalentsTabs.build(active: "anything_else")

    assert tabs.none? { |t| t[:active] }
  end

  test "returns translated labels in pt" do
    I18n.with_locale(:pt) do
      tabs = TalentsTabs.build(active: "sobre")
      assert_equal [ "Sobre", "Notícias e Críticas", "Programação" ], tabs.map { |t| t[:label] }
    end
  end

  test "returns translated labels in en" do
    I18n.with_locale(:en) do
      tabs = TalentsTabs.build(active: "sobre")
      assert_equal [ "About", "News & Reviews", "Schedule" ], tabs.map { |t| t[:label] }
    end
  end

  test "sobre tab links to talents_members_path" do
    I18n.with_locale(:pt) do
      tabs = TalentsTabs.build(active: "sobre")
      sobre = tabs.find { |t| t[:label] == "Sobre" }
      assert_equal "/pt/talents/apresentacao", sobre[:href]
    end
  end

  test "noticias_e_criticas tab links to talents_news_path" do
    I18n.with_locale(:pt) do
      tabs = TalentsTabs.build(active: "noticias_e_criticas")
      noticias = tabs.find { |t| t[:label] == "Notícias e Críticas" }
      assert_equal "/pt/talents/noticias_e_criticas", noticias[:href]
    end
  end

  test "programacao tab links to talents_programacao_path" do
    I18n.with_locale(:pt) do
      tabs = TalentsTabs.build(active: "programacao")
      programacao = tabs.last
      assert_equal "/pt/talents/programacao", programacao[:href]
    end
  end

  test "tab hrefs include current locale" do
    I18n.with_locale(:en) do
      tabs = TalentsTabs.build(active: "sobre")
      sobre = tabs.first
      assert_equal "/en/talents/apresentacao", sobre[:href]
    end
  end
end
