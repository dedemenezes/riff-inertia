module MostraFilterOptions
  extend ActiveSupport::Concern

  def set_mostra_filter_options(mostras, peliculas_scope)
    @submostras_filter = build_submostras_filter(mostras)
    @paises_filter = build_mostra_paises_filter(peliculas_scope)

    genres = @pelicula_collection_service.collection_for_genres
    @genres_filter = strings_to_filter_collection(genres, "genero")

    directors = @pelicula_collection_service.collection_for_directors
    @directors_filter = strings_to_filter_collection(directors, "direcao")

    actors = @pelicula_collection_service.collection_for_actors
    @actors_filter = strings_to_filter_collection(actors, "elenco")
  end

  def build_submostras_filter(mostras)
    sorted = mostras.sort_by(&:permalink_pt)
    to_filter_collection(sorted, "mostra") do |mostra, item|
      item["id"] = mostra.id
      item["permalink_pt"] = mostra.permalink_pt
      item["nome_abreviado"] = mostra.nome_abreviado
      item["tag_class"] = mostra.tag_class
      item["display_name"] = mostra.display_name
    end
  end

  def build_mostra_paises_filter(peliculas_scope)
    paises = peliculas_scope.flat_map(&:paises)
                            .uniq
                            .sort_by(&:nome_pais)

    to_filter_collection(paises, "pais") do |pais, item|
      item["id"] = pais.id
      item["nome_pais"] = pais.nome_pais
    end
  end

  private

  def to_filter_collection(records, label_key, locale: I18n.locale)
    label = I18n.t("filter.#{label_key}", locale:)
    records.map { |record|
      item = {
        "filter_value" => record.filter_value,
        "filter_display" => record.filter_display(locale:),
        "filter_label" => label
      }
      yield(record, item) if block_given?
      item
    }
  end

  def strings_to_filter_collection(strings, label_key, locale: I18n.locale)
    label = I18n.t("filter.#{label_key}", locale:)
    strings.map { |string|
      {
        "filter_value" => string,
        "filter_display" => string,
        "filter_label" => label
      }
    }
  end
end
