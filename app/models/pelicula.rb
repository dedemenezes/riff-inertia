class Pelicula < ApplicationRecord
  include TeamParseable, Filterable, Displayable, Imageable

  CAROUSEL_IMAGES_AMOUNT = 3
  METHODS_NEEDED = %i[
    display_titulo
    display_sinopse
    genre
    display_paises
    diretor_team
    fotografia_team
    producaoempresa_team
    roteiro_team
    montagem_team
    imageURL
    posterImageURL
    director_image
    carousel_images
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
    programacoes.order(:data).each_slice(3).map do |programacoes_slice|
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
