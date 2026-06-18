# frozen_string_literal: true

class IngressosTabs
  TABS = [
    { key: "como_comprar", label_key: "ingressos.tabs.como_comprar", path_helper: :ingressos_como_comprar_path },
    { key: "pacotes", label_key: "ingressos.tabs.pacotes", path_helper: :ingressos_pacotes_path },
    { key: "proximas_sessoes", label_key: "ingressos.tabs.proximas_sessoes", path_helper: :ingressos_proximas_sessoes_path }
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
