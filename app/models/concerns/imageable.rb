module Imageable
  extend ActiveSupport::Concern

  # Including model MUST define:
  #   def image_path_prefix = "imagens/noticias"   # no leading/trailing slash
  #   def image_default_size = "medium2"

  def image_path_prefix
    raise NotImplementedError, "#{self.class} must implement #image_path_prefix"
  end

  def image_default_size
    raise NotImplementedError, "#{self.class} must implement #image_default_size"
  end

  def image_url(size = image_default_size)
    return nil if imagem.blank?

    build_image_url(imagem, size)
  end

  protected

  def build_responsive_image(img_name, variants:, sizes:, src_folder:)
    return nil if img_name.blank?

    {
      src: build_image_url(img_name, src_folder),
      srcset: variants.map { |folder, width| "#{build_image_url(img_name, folder)} #{width}w" }.join(", "),
      sizes: sizes
    }
  end

  def build_image_url(img_name, img_size)
    "#{ENV.fetch("IMAGES_BASE_URL")}/#{image_path_prefix}/#{img_size}/#{img_name}"
  end
end
