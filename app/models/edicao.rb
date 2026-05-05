class Edicao < ApplicationRecord
  CURRENT_ID = 13

  has_many :programacoes
  has_many :mostras
  has_many :cinemas
  has_many :peliculas
  has_many :importacao_convidados
  has_many :importacoesprogs, class_name: "Importacoesprog"

  def self.current
    Rails.cache.fetch("edicao/current", expires_in: 1.hour) do
      find(CURRENT_ID)
    end
  end

  def self.previous
    Rails.cache.fetch("edicao/previous", expires_in: 1.hour) do
      find(CURRENT_ID - 1)
    end
  end
end
