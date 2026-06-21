class Pelicula < ApplicationRecord
  include TeamParseable, Filterable, Displayable, Imageable
  include Rails.application.routes.url_helpers

  CAROUSEL_IMAGES_AMOUNT = 3
  BANNER_SRCSET_WIDTHS = [
    [ "large", 300 ],
    [ "original", 1920 ]
  ].freeze
  CARD_IMAGE_SIZES = "(min-width: 1024px) 33vw, (min-width: 768px) 50vw, 100vw".freeze
  # Widths are approximations until the S3 folder dimensions are confirmed.
  CARD_IMAGE_VARIANTS = [
    [ "medium", 400 ],
    [ "medium2", 600 ],
    [ "large", 800 ]
  ].freeze

  METHODS_NEEDED = %i[
    display_titulo
    display_sinopse
    genre
    display_paises
    displayTeamsHeader
    display_sobre_o_filme
    teams
    imageURL
    banner_image
    posterImageURL
    director_image
    carousel_images
    mostra_name
    mostra_tag_class
    programacoesAsJson
    url
    mostra_display_name
  ]

  COLUMNS_NEEDED = %i[
    elenco_coord_int
    edicao_id
    imagem
    titulo_ingles_coord_int
    titulo_portugues_coord_int
    ano_coord_int
    duracao_coord_int
    cor_coord_int
    catalogo_ficha_2007
    diretor_coord_int
    youtube_link_trailer
    vimeo_link_trailer
  ]

  CARD_COLUMNS = %i[
    edicao_id
    duracao_coord_int
  ].freeze
  CARD_METHODS = %i[
    display_titulo
    genre
    display_paises
    card_image
    mostra_tag_class
    mostra_display_name
    url
  ].freeze

  belongs_to :importacao
  belongs_to :edicao
  belongs_to :mostra
  belongs_to :genero, optional: true
  belongs_to :metragem, optional: true
  has_many :atores_peliculas
  has_many :galerias
  has_many :paises_peliculas
  has_many :paises, through: :paises_peliculas
  has_many :programacoes
  has_many :peliculas_tags

  scope :search_by_title, ->(term) {
    return all if term.blank?

    term = "%#{term.downcase}%"

    where(
      "LOWER(titulo_ingles_coord_int) LIKE :term OR
      LOWER(titulo_original_coord_int) LIKE :term OR
      LOWER(titulo_portugues_coord_int) LIKE :term OR
      LOWER(titulo_ingles_semartigo) LIKE :term OR
      LOWER(titulo_portugues_semartigo) LIKE :term",
      term: term
    )
  }

  scope :search_by_genre, ->(genre, locale: I18n.locale) {
    return all if genre.blank?

    locale_index = locale == :en ? -1 : 1
    genre = "%#{genre}%"
    where(
      "SUBSTRING_INDEX(SUBSTRING_INDEX(catalogo_ficha_2007, ' ', 1), '/', ?) LIKE ?",
      locale_index,
      genre
    )
  }

  def programacoesAsJson
    programacoes.sort_by(&:data).each_slice(3).map do |programacoes_slice|
      programacoes_slice.map do |prog|
        {
          data: prog.display_date,
          sessao: prog.display_sessao,
          ingresso_url_venda: prog.ingresso_url_venda,
          cinema_name: prog.cinema_name,
          cinema_address: prog.cinema_address
        }
      end
    end
  end

  def mostra_name
    mostra.filter_display
  end

  def mostra_display_name
    mostra.filter_display_name
  end

  def mostra_tag_class
    mostra.tag_class
  end

  def image_path_prefix = "#{edicao.descricao}/site/peliculas"
  def image_default_size = "original"

  def card_image
    image_name = imagem.presence || imagem_producao.presence

    build_responsive_image(
      image_name,
      variants: CARD_IMAGE_VARIANTS,
      sizes: CARD_IMAGE_SIZES,
      src_folder: "medium2"
    )
  end

  def imageURL(image_name = nil, size = "original")
    image_name ||= imagem
    image_name = imagem_producao if image_name.blank?
    return if image_name.blank?

    build_image_url(image_name, size)
  end

  def posterImageURL(image_name = nil, size = "large")
    image_name ||= imagem_producao
    build_image_url(image_name, size)
  end

  def banner_image
    return unless imagem.present?

    {
      src: build_image_url(imagem, "large"),
      srcset: BANNER_SRCSET_WIDTHS.map { |folder, w| "#{build_image_url(imagem, folder)} #{w}w" }.join(", "),
      sizes: "100vw"
    }
  end

  def carousel_images
    image_name = imagem
    return [] if image_name.nil? || image_name.empty?

    (2..CAROUSEL_IMAGES_AMOUNT + 1).map do |i|
      image_number = "0#{i}"
      digits_after_f_regex = /(\w+_f)\d+/
      rotated = imagem.gsub(digits_after_f_regex, "\\1#{image_number}")
      { path: build_image_url(rotated, "original") }
    end.compact_blank
  end

  def director_image
    return if imagem_diretor.nil? || imagem_diretor.empty?

    imageURL(imagem_diretor)
  end

  def url
    pelicula_path(permalink: self.permalink)
  end
end
