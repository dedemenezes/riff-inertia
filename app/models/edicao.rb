class Edicao < ApplicationRecord
  include Imageable

  CURRENT_ID = 13

  has_many :programacoes
  has_many :mostras
  has_many :cinemas
  has_many :peliculas
  has_many :importacao_convidados
  has_many :importacoesprogs, class_name: "Importacoesprog"

  def image_path_prefix = "imagens/edicoes"
  def image_default_size = "small"

  def image_url(size = image_default_size)
    return nil if cartaz.blank?

    build_image_url(cartaz, size)
  end

  def self.current
    Rails.cache.fetch("edicao/current/#{CURRENT_ID}", expires_in: 1.hour) do
      find(CURRENT_ID)
    end
  end

  def self.previous
    Rails.cache.fetch("edicao/previous/#{CURRENT_ID}", expires_in: 1.hour) do
      where("id < ?", CURRENT_ID).order(id: :desc).first
    end
  end
end
