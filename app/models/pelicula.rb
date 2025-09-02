class Pelicula < ApplicationRecord
  belongs_to :importacao
  belongs_to :edicao
  belongs_to :mostra
  has_many :atores_peliculas
  has_many :galerias
  has_many :paises_peliculas
  has_many :paises, through: :paises_peliculas
  has_many :programacoes
  has_many :peliculas_tags
end
