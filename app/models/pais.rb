class Pais < ApplicationRecord
  include ActiveSupport::Inflector

  has_many :paises_peliculas

  def filter_value
    id
  end

  def filter_display
    nome_without_special_char = transliterate(self.nome_pais, :pt).downcase.gsub(" ", "_")
    if I18n.locale == :pt
      I18n.t("countries.#{nome_without_special_char}")
    else
      I18n.t("countries.#{nome_without_special_char}")
    end
  end
end
