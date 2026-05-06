class Webdoor < ApplicationRecord
  include Imageable

  belongs_to :idioma

  scope :published, -> { where(ativo: 1) }
  scope :ordered, -> { published.order(:ordem) }

  def image_path_prefix = "imagens/webdoors"
  def image_default_size = "small"

  alias_method :desktop_image_url, :image_url

  def mobile_image_url
    return "" if imagem_mobile.blank?

    build_image_url(imagem_mobile, "small_mobile")
  end

  def permalink
    return "" if url.blank?

    url.split("/").last
  end
end
