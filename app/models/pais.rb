class Pais < ApplicationRecord
  has_many :paises_peliculas

  def filter_value
    id
  end

  def filter_display
    nome_pais
  end
end
