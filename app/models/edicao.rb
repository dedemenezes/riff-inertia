class Edicao < ApplicationRecord
  has_many :programacoes
  has_many :mostras
  has_many :cinemas
  has_many :peliculas
  has_many :importacao_convidados
  has_many :importacoesprogs, class_name: "Importacoesprog"
end
