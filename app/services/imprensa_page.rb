# frozen_string_literal: true

class ImprensaPage
  # Legacy CMS only has Portuguese content for Imprensa. When a locale is not
  # mapped here there is no content, so navigation to it is omitted entirely.
  LEGACY_ROUTES = {
    pt: "/br/imprensa/"
  }.freeze

  # Legacy content rarely changes and is written by the legacy admin, so cache
  # the lookup to avoid a Pagina query on every localized page load (this runs
  # in inertia_share + the secondary nav). TTL bounds staleness since the legacy
  # app cannot bust this cache.
  CACHE_TTL = 1.hour

  def self.for(locale)
    rota = LEGACY_ROUTES[locale&.to_sym]
    return nil unless rota

    Rails.cache.fetch("imprensa_page/#{rota}", expires_in: CACHE_TTL) do
      Pagina.find_by(rota: rota)
    end
  end
end
