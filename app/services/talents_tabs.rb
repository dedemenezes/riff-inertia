# frozen_string_literal: true

# Builds the Talents section tabs (Sobre / Notícias e Críticas / Programação)
# shared across the three Talents pages. Hrefs are placeholders ("#") until
# the destination routes exist.
class TalentsTabs
  TABS = [
    { key: "sobre", path: "#" },
    { key: "noticias_e_criticas", path: "#" },
    { key: "programacao", path: "#" }
  ].freeze

  def self.build(active:)
    TABS.map do |tab|
      {
        label: I18n.t("talents.tabs.#{tab[:key]}"),
        href: tab[:path],
        active: tab[:key] === active.to_s
      }
    end
  end
end
