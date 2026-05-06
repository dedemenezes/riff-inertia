# frozen_string_literal: true

# Builds the Talents section tabs (Sobre / Notícias e Críticas / Programação)
# shared across the three Talents pages. Hrefs are placeholders ("#") until
# the destination routes exist.
class TalentsTabs
  TABS = [
    { key: "sobre", path_helper: :talents_members_path },
    { key: "noticias_e_criticas", path_helper: :talents_news_path },
    { key: "programacao", path_helper: :talents_programacao_path }
  ].freeze

  def self.build(active:)
    helpers = Rails.application.routes.url_helpers

    TABS.map do |tab|
      href = if tab[:path_helper] && helpers.respond_to?(tab[:path_helper])
        helpers.public_send(tab[:path_helper], locale: I18n.locale)
      else
        "#"
      end

      {
        label: I18n.t("talents.tabs.#{tab[:key]}"),
        href: href,
        active: tab[:key] === active.to_s
      }
    end
  end
end
