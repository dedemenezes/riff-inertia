class Webdoor < ApplicationRecord
  BASE_IMAGE_PATH = "/imagens/webdoors"
  belongs_to :idioma

  scope :published, -> { where(ativo: 1) }
  scope :ordered, -> { published.order(:ordem) }

  def permalink
    return "" if url.blank?

     url.split("/").last
  end

  def mobile_image_url
    return "" if imagem_mobile.blank?

    "#{ENV.fetch("IMAGES_BASE_URL")}#{BASE_IMAGE_PATH}/small_mobile/#{imagem_mobile}"
  end

  def desktop_image_url
    return "" if imagem.blank?

    "#{ENV.fetch("IMAGES_BASE_URL")}#{BASE_IMAGE_PATH}/small/#{imagem}"
  end
end
