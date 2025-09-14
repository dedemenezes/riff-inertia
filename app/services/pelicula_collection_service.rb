class PeliculaCollectionService
  include Filterable

  def self.for(klass)
    new(klass)
  end

  def initialize(klass = Pelicula)
    @klass = klass
  end

  def collection_for_genres
    # edicao_id = CONSTANT
    # Rails.cache.fetch("genres-for-edicao-#{edicao_id}-#{I18n.locale}", expires_in: 12.hours) do
    locale_index = I18n.locale == :en ? 1 : 0
    @klass.collection_for(:catalogo_ficha_2007, :genero) do |fichas|
      fichas.map { |ficha| ficha.split(" ").first&.split("/")&.at(locale_index) }
    end
  end

  def collection_for_directors
    # Rails.cache.fetch("directors-for-edicao-#{edicao_id}", expires_in: 12.hours) do
    @klass.collection_for(:diretor_coord_int, :direcao) do |directors|
      directors.map(&:strip)
    end
  end

  def collection_for_actors
    @klass.collection_for(:elenco_coord_int, :elenco) do |actors|
      actors.flat_map { |cast| cast.split(",").map(&:strip) }
    end
  end

  # get from cache and search for pelicula ids
  def with_actor(actor_name, edicao_id)
    mapping = actor_to_pelicula_mapping(edicao_id)
    pelicula_ids = mapping[actor_name] || mapping[actor_name.downcase] || []

    @klass.where(id: pelicula_ids)
  end

  private

  def actor_to_pelicula_mapping(edicao_id)
    cache_key = "actor-pelicula-mapping-#{edicao_id}"

    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      build_actor_mapping(edicao_id)
    end
  end

  def build_actor_mapping(edicao_id)
    mapping = {}

    @klass
      .where(edicao_id: edicao_id)
      .where.not(elenco_coord_int: [ nil, "" ])
      .pluck(:id, :elenco_coord_int)
      .each do |pelicula_id, cast_string|
        process_cast_string(cast_string, pelicula_id, mapping)
      end

    # Remove duplicates and return
    mapping.transform_values(&:uniq)
  end

  def process_cast_string(cast_string, pelicula_id, mapping)
    cast_string.split(",").each do |actor|
      clean_actor = actor.strip
      next if clean_actor.blank?

      # Store both exact name and normalized version
      mapping[clean_actor] ||= []
      mapping[clean_actor.downcase] ||= []

      mapping[clean_actor] << pelicula_id
      mapping[clean_actor.downcase] << pelicula_id
    end
  end
end
