class Idioma < ApplicationRecord
  has_many :clippings
  has_many :noticias
  has_many :paginas
  has_many :videos
  has_many :webdoors
  # has_many :usuarios
end
