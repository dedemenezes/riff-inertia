class Pais < ApplicationRecord
  include ActiveSupport::Inflector

  has_many :paises_peliculas

  def filter_value
    id
  end

  def filter_display(locale: I18n.locale)
    nome_without_special_char = transliterate(self.nome_pais, :pt).downcase.gsub(" ", "_")
    I18n.t("countries.#{nome_without_special_char}", locale:)
  end
end
