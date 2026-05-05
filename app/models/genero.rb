class Genero < ApplicationRecord
  has_many :peliculas

  def filter_value
    id
  end

  def filter_display(locale: I18n.locale)
    locale == :en ? nome_en : nome_pt
  end
end
