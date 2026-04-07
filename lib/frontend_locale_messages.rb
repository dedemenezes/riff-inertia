# frozen_string_literal: true

# Full merged I18n tree for one locale, as JSON-safe string keys (for Inertia / Vue).
class FrontendLocaleMessages
  def self.as_json_hash(locale = I18n.locale)
    tree = translations_for(locale.to_sym)
    tree.deep_stringify_keys
  end
  def self.translations_for(locale_sym)
    store = I18n.backend.send(:translations)
    store[locale_sym].presence || {}
  end
  private_class_method :translations_for
end
