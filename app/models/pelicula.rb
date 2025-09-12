class Pelicula < ApplicationRecord
  include ActionView::Helpers::TextHelper
  include TeamParseable

  CAROUSEL_IMAGES_AMOUNT = 3
  METHODS_NEEDED = %i[
    display_sinopse
    display_titulo
    montagem_team
    diretor_team
    fotografia_team
    producaoempresa_team
    roteiro_team
    montagem_team
    imageURL
    director_image
    carousel_images
    display_paises
    genre
    mostra_name
    mostra_tag_class
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
  ]

  belongs_to :importacao
  belongs_to :edicao
  belongs_to :mostra
  has_many :atores_peliculas
  has_many :galerias
  has_many :paises_peliculas
  has_many :paises, through: :paises_peliculas
  has_many :programacoes
  has_many :peliculas_tags

  def self.genres_for(edicao_id)
      # Rails.cache.fetch("genres-for-edicao-#{edicao_id}-#{I18n.locale}", expires_in: 12.hours) do
      locale_index = I18n.locale == :en ? 1 : 0

      genres = where(edicao_id: edicao_id)
        .where.not(catalogo_ficha_2007: [ nil, "" ])
        .pluck(:catalogo_ficha_2007)
        .map { |raw| raw.split(" ").first&.split("/")&.[](locale_index) }
        .compact
        .uniq
        .sort

      genres.map do |genre|
        {
          "filter_display" => genre,
          "filter_value" => genre,
          "filter_label" => I18n.t("filter.genero")
        }
      end
    # end
  end

  def self.directors_for(edicao_id)
      # Rails.cache.fetch("directors-for-edicao-#{edicao_id}", expires_in: 12.hours) do
      where(edicao_id: edicao_id)
        .where.not(diretor_coord_int: [ nil, "" ])
        .pluck(:diretor_coord_int)
        .map(&:strip)
        .uniq
        .compact
        .sort
        .map do |director|
          {
            "filter_display" => director,
            "filter_value" => director,
            "filter_label" => I18n.t("filter.direcao")
          }
        end
    # end
  end

  # Filter options
  def self.cast_for(edicao_id)
    # Filter collection must be cached
    all_cast_for(edicao_id).map do |cast|
      {
        "filter_display": cast,
        "filter_value": cast,
        "filter_label": I18n.t("filter.elenco")
      }
    end
  end

  # TODO: WE GET 1k+. think about it
  def self.all_cast_for(edicao_id)
    where(edicao_id: edicao_id)
      .where.not(elenco_coord_int: [ nil, "" ])
      .pluck(:elenco_coord_int)
      .flat_map { |cast| cast.split(",").map(&:strip) }
      .reject(&:blank?).uniq.sort
  end

  def genre
    return "TBD" unless catalogo_ficha_2007

    locales = {
      "pt": 0,
      "en": 1
    }
    catalogo_ficha_2007.split(" ")&.first.split("/")[locales[I18n.locale]] || "TBD"
  end

  def display_paises
    all_paises = paises.map { |it| it.nome_pais }
    # TODO: ORDER HOW?
    counter = all_paises.length
    if counter > 1
      "#{all_paises.first} + #{pluralize(counter - 1, "país", "países")}"
    else
      all_paises.first
    end
  end

  def display_titulo
    I18n.locale == :pt ? titulo_portugues_coord_int : titulo_ingles_coord_int
  end

  def display_sinopse
    I18n.locale == :pt ? sinopse_port_export : sinopse_ing_export
  end

  def diretor_team
    parse_team(diretor_coord_int)
  end

  def fotografia_team
    parse_team(fotografia_coord_int)
  end

  def producaoempresa_team
    parse_team(producaoempresa_coord_int)
  end

  def roteiro_team
    parse_team(roteiro_coord_int)
  end

  def montagem_team
    parse_team(montagem_coord_int)
  end

  def mostra_name
    mostra.filter_display
  end

  def mostra_tag_class
    mostra.tag_class
  end

  def imageURL(image_name = nil)
    image_name ||= self.imagem
      # TODO: CACHE
      # TODO: IF WE WANT DIFFERENT SIZE?
      # Rails.cache.fetch("image-for-pelicula-#{id}", expires_in: 12.hours) do
      "#{ENV.fetch("IMAGES_BASE_URL", "DEFINE_BASE_URL_ENV")}/#{ApplicationRecord::EDICAO_ATUAL_ANO}/site/peliculas/large/#{image_name}"
    # end
  end

  # TODO: RETHINK THIS MAYBE THERE ISN'T TWO IMAGES
  def carousel_images
    image_name = imagem
    return if image_name.nil? || image_name.empty?

    (2..CAROUSEL_IMAGES_AMOUNT + 1).to_a.map do |i|
      image_number = "0#{i}"
      digits_after_f_regex = /(\w+_f)\d+/
      image_name = imagem.gsub(digits_after_f_regex, "\\1#{image_number}")
      {
        path: imageURL(image_name)
      }
    end.compact_blank
  end

  def director_image
    return if imagem_diretor.nil? || imagem_diretor.empty?

    imageURL(imagem_diretor)
  end


  # Caches actor names with pelicula id
  def self.actor_to_pelicula_mapping(edicao_id)
    Rails.cache.fetch("actor-pelicula-mapping-#{edicao_id}", expires_in: 6.hours) do
      mapping = {}

      where(edicao_id: edicao_id)
        .where.not(elenco_coord_int: [ nil, "" ])
        .pluck(:id, :elenco_coord_int)
        .each do |pelicula_id, cast_string|
          cast_string.split(",").each do |actor|
            clean_actor = actor.strip
            next if clean_actor.blank?

            mapping[clean_actor] ||= []
            mapping[clean_actor.downcase] ||= []
            # Store both exact name and normalized version
            mapping[clean_actor] << pelicula_id
            mapping[clean_actor.downcase] << pelicula_id
          end
        end

      # Remove duplicates and return
      mapping.each { |ky, value| mapping[ky] = value.uniq }
      mapping
    end
  end

  # get from cache and search for pelicula ids
  def self.with_actor(actor_name, edicao_id)
    mapping = actor_to_pelicula_mapping(edicao_id)
    pelicula_ids = mapping[actor_name] || mapping[actor_name.downcase] || []

    where(id: pelicula_ids)
  end
end
