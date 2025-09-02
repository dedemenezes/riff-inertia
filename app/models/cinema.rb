class Cinema < ApplicationRecord
  belongs_to :bairro
  belongs_to :edicao
  has_many :programacoes
end
