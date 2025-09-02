class Importacoesprog < ApplicationRecord
  belongs_to :edicao
  has_many :programacoes
end
