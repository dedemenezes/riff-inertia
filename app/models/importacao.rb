class Importacao < ApplicationRecord
  belongs_to :edicao
  has_many :mostras
  has_many :peliculas
end
