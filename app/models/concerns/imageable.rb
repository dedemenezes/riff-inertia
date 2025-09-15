module Imageable
  extend ActiveSupport::Concern
  CAROUSEL_IMAGES_AMOUNT = 3

  # TODO: RETHINK THIS MAYBE THERE ISN'T TWO IMAGES
  def carousel_images
    image_name = imagem
    return [] if image_name.nil? || image_name.empty?

    (2..CAROUSEL_IMAGES_AMOUNT + 1).to_a.map do |i|
      image_number = "0#{i}"
      digits_after_f_regex = /(\w+_f)\d+/
      image_name = imagem.gsub(digits_after_f_regex, "\\1#{image_number}")
      {
        path: imageURL(image_name)
      }
    end.compact_blank
  end

  def imageURL(image_name = nil, size = "original")
    image_name ||= self.imagem
    return unless image_name

    # TODO: CACHE
    # TODO: IF WE WANT DIFFERENT SIZE?
    # Rails.cache.fetch("image-for-pelicula-#{id}", expires_in: 12.hours) do
    build_image_url(image_name, size)
  end

  # TODO: Define default size for all images in the website
  def posterImageURL(image_name = nil, size = "large")
    image_name ||= self.imagem_producao
    # TODO: CACHE
    # TODO: IF WE WANT DIFFERENT SIZE?
    # Rails.cache.fetch("image-for-pelicula-#{id}", expires_in: 12.hours) do
    build_image_url(image_name, size)
    # end
  end

  private

  def build_image_url(img_name, img_size = "large2")
    "#{ENV.fetch("IMAGES_BASE_URL", "DEFINE_BASE_URL_ENV")}/#{ApplicationRecord::EDICAO_ATUAL_ANO}/site/peliculas/#{img_size}/#{img_name}"
  end
end
