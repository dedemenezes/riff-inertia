class Programacao < ApplicationRecord
  has_many :cineencontros
  belongs_to :cinema
  belongs_to :pelicula
  belongs_to :importacoesprog
  belongs_to :edicao
  has_many :logs
end
