module ProgramFilterOptions
  extend ActiveSupport::Concern
  def set_filter_options(base_scope)
    @paises_filter   = build_paises_filter(base_scope)

    @mostras_filter  = build_mostra_filter
    @cinemas_filter = build_cinema_filter

    @sessoes = build_sessoes_filter

    genres = @pelicula_collection_service.collection_for_genres
    @genres_filter = strings_to_filter_collection(genres, "genero")

    directors = @pelicula_collection_service.collection_for_directors
    @directors_filter = strings_to_filter_collection(directors, "direcao")

    actors = @pelicula_collection_service.collection_for_actors
    @actors_filter = strings_to_filter_collection(actors, "elenco")
  end

  def build_sessoes_filter
    programacoes = Programacao.where(edicao_id: @current_edicao)
                               .to_a
                               .uniq { |p| p.sessao }
                               .sort_by { |it| it.sessao }
    to_filter_collection(programacoes, "sessao") do |prog, item|
      item["sessao"] = prog.sessao
      item["display_sessao"] = prog.display_sessao
    end
  end

  def build_paises_filter(base_scope)
    paises = base_scope.includes(pelicula: :paises)
                       .map { _1.pelicula.paises }
                       .flatten
                       .uniq
                       .sort_by { |it| it.nome_pais }

    to_filter_collection(paises, "pais") do |pais, item|
      item["id"] = pais.id
      item["nome_pais"] = pais.nome_pais
    end
  end

  def build_cinema_filter
    cinemas = Cinema.where(edicao_id: @current_edicao)
                    .to_a
                    .uniq { |m| m.id }
                    .sort_by { |it| it.nome }

    to_filter_collection(cinemas, "cinema") do |cinema, item|
      item["id"] = cinema.id
      item["nome"] = cinema.nome
      item["endereco"] = cinema.endereco
      item["edicao_id"] = cinema.edicao_id
    end
  end

  def build_mostra_filter
    mostras = Mostra.where(edicao_id: @current_edicao)
                    .to_a
                    .uniq { |mostra| mostra.id }
                    .sort_by { |mostra| mostra.permalink_pt }

    to_filter_collection(mostras, "mostra") do |mostra, item|
      item["id"] = mostra.id
      item["permalink_pt"] = mostra.permalink_pt
      item["nome_abreviado"] = mostra.nome_abreviado
      item["tag_class"] = mostra.tag_class
      item["display_name"] = mostra.display_name
    end
  end

  def set_pelicula_collection_service
    @pelicula_collection_service = PeliculaCollectionService.new
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
