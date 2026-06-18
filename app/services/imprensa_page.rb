# frozen_string_literal: true

class ImprensaPage
  # Legacy CMS only has Portuguese content for Imprensa. When a locale is not
  # mapped here there is no content, so navigation to it is omitted entirely.
  LEGACY_ROUTES = {
    pt: "/br/imprensa/"
  }.freeze

  def self.for(locale)
    rota = LEGACY_ROUTES[locale&.to_sym]
    return nil unless rota

    Pagina.find_by(rota: rota)
  end
end
