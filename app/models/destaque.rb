class Destaque < ApplicationRecord
  belongs_to :idioma
  belongs_to :tipo
  BASE_IMAGE_PATH = "/imagens/destaques/small"

  scope :active, -> { where(ativo: 1).order(:ordem) }

  def image_url
    return "" if imagem.blank?

    "#{ENV.fetch("IMAGES_BASE_URL")}#{BASE_IMAGE_PATH}/#{imagem}"
  end
end
