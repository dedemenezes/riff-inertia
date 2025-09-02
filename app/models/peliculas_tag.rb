class PeliculasTag < ApplicationRecord
  belongs_to :pelicula
  belongs_to :tag
end
