class Mostra < ApplicationRecord
  MOSTRA_MAP = {
    "premiere-brasil": "tag-premiere-brasil",
    "premiere-latina": "tag-premiere-latina",
    "gala-de-abertura": "tag-gala-abertura",
    "gala-de-encerramento": "tag-gala-encerramento",
    "resistencias": "tag-resistencias",
    "cine-memoria": "tag-cine-memoria",
    "midnight-movies": "tag-midnight-movies",
    "cinema-capacete": "tag-cinema-capacete",
    "classicos-cults": "tag-classicos--cults",
    "expectativa": "tag-expectativas",
    "itinerarios-unicos": "tag-itinerarios-unicos",
    "panorama-mundial": "tag-panorama-mundial"
  }

  belongs_to :importacao
  belongs_to :edicao
  has_many :peliculas

  def tag_class
    MOSTRA_MAP.find { |key, _| permalink_pt.include?(key.to_s) }&.last || "tag-default"
  end

  def display_name
    nome_abreviado.split(/[-:]/).first
  end
end
