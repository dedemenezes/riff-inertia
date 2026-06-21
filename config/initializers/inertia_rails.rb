# frozen_string_literal: true

InertiaRails.configure do |config|
  config.version = ViteRuby.digest
  config.encrypt_history = true
  config.always_include_errors_hash = true
  config.ssr_enabled = ENV.fetch("INERTIA_SSR_ENABLED", "false") == "true"
  config.ssr_url = ENV.fetch("INERTIA_SSR_URL", "http://localhost:13714")
end
