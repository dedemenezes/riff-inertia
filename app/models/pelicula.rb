class Pelicula < ApplicationRecord
  include ActionView::Helpers::TextHelper
  include TeamParseable, Filterable

  CAROUSEL_IMAGES_AMOUNT = 3
  METHODS_NEEDED = %i[
    display_sinopse
    display_titulo
    diretor_team
    fotografia_team
    producaoempresa_team
    roteiro_team
    montagem_team
    imageURL
    posterImageURL
    director_image
    carousel_images
    display_paises
    genre
    mostra_name
    mostra_tag_class
    programacoesAsJson
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

  def self.collection_for_genres
    # Rails.cache.fetch("genres-for-edicao-#{edicao_id}-#{I18n.locale}", expires_in: 12.hours) do
    locale_index = I18n.locale == :en ? 1 : 0
    collection_for(:catalogo_ficha_2007, :genero) do |fichas|
      fichas.map { |ficha| ficha.split(" ").first&.split("/")&.at(locale_index) }
    end
  end

  def self.collection_for_directors
    # Rails.cache.fetch("directors-for-edicao-#{edicao_id}", expires_in: 12.hours) do
    collection_for(:diretor_coord_int, :direcao) do |directors|
      directors.map(&:strip)
    end
  end

  def self.collection_for_actors
    collection_for(:elenco_coord_int, :elenco) do |actors|
      actors.flat_map { |cast| cast.split(",").map(&:strip) }
    end
  end

  def programacoesAsJson
    JSON.parse(programacoes.to_json(
      only: [ :id, :data, :sessao, :ingresso_url_venda ],
      methods: [ :display_sessao, :cinema_name, :cinema_address ]
    ))
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

  # TODO: Define default size for all images in the website
  def posterImageURL(image_name = nil, size = "large")
    image_name ||= self.imagem_producao
      # TODO: CACHE
      # TODO: IF WE WANT DIFFERENT SIZE?
      # Rails.cache.fetch("image-for-pelicula-#{id}", expires_in: 12.hours) do
      "#{ENV.fetch("IMAGES_BASE_URL", "DEFINE_BASE_URL_ENV")}/#{ApplicationRecord::EDICAO_ATUAL_ANO}/site/peliculas/#{size}/#{image_name}"
    # end
  end

  def imageURL(image_name = nil, size = "original")
    image_name ||= self.imagem
      # TODO: CACHE
      # TODO: IF WE WANT DIFFERENT SIZE?
      # Rails.cache.fetch("image-for-pelicula-#{id}", expires_in: 12.hours) do
      "#{ENV.fetch("IMAGES_BASE_URL", "DEFINE_BASE_URL_ENV")}/#{ApplicationRecord::EDICAO_ATUAL_ANO}/site/peliculas/#{size}/#{image_name}"
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
