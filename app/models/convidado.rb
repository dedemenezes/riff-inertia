class Convidado < ApplicationRecord
  belongs_to :pelicula
  belongs_to :edicao
  belongs_to :importacao_convidado
end
