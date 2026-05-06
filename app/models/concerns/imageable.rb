module Imageable
  extend ActiveSupport::Concern

  # Including model MUST define:
  #   def image_path_prefix = "imagens/noticias"   # no leading/trailing slash
  #   def image_default_size = "medium2"

  def image_url(size = image_default_size)
    return nil if imagem.blank?

    build_image_url(imagem, size)
  end

  protected

  def build_image_url(img_name, img_size)
    "#{ENV.fetch("IMAGES_BASE_URL")}/#{image_path_prefix}/#{img_size}/#{img_name}"
  end
end
