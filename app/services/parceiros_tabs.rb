# frozen_string_literal: true

class ParceirosTabs
  TABS = [
    { key: "parceiros", label_key: "navigation.parceiros_tabs.parceiros", path_helper: :festival_parceiros_path },
    { key: "editoriais", label_key: "navigation.parceiros_tabs.editoriais", path_helper: :festival_parceiros_editoriais_path }
  ].freeze

  def self.build(active:)
    helpers = Rails.application.routes.url_helpers

    TABS.map do |tab|
      {
        label: I18n.t(tab[:label_key]),
        href: helpers.public_send(tab[:path_helper], locale: I18n.locale),
        active: tab[:key] == active.to_s
      }
    end
  end
end
