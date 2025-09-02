class Mostra < ApplicationRecord
  belongs_to :importacao
  belongs_to :edicao
  has_many :peliculas
end
