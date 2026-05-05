# frozen_string_literal: true

# Applies program listing filters from request params to a Programacao relation
# and builds selected filter state for Inertia props / tab URLs.
class ProgramacoesFilter
  Result = Struct.new(
    :relation,
    :selected_filters,
    :selected_query,
    :selected_mostra,
    :selected_cinema,
    :selected_pais,
    :selected_sessao,
    :selected_genre,
    :selected_director,
    :selected_actor,
    :selected_date,
    :available_dates,
    keyword_init: true
  )

  def initialize(relation:, params:, filter_options:, pelicula_collection_service:)
    @relation = relation
    @params = params
    @edicao_id = Edicao.current.id
    @mostras_filter = filter_options.fetch(:mostras)
    @cinemas_filter = filter_options.fetch(:cinemas)
    @paises_filter = filter_options.fetch(:paises)
    @sessoes = filter_options.fetch(:sessoes)
    @genres_filter = filter_options.fetch(:genres)
    @directors_filter = filter_options.fetch(:directors)
    @pelicula_collection_service = pelicula_collection_service
  end

  def call
    selected_filters = {}
    relation = @relation

    selected_query = nil
    selected_mostra = nil
    selected_cinema = nil
    selected_pais = nil
    selected_sessao = nil
    selected_genre = nil
    selected_director = nil
    selected_actor = nil

    if @params[:query].present?
      pelicula_ids = Pelicula.where(edicao_id: @edicao_id)
                             .search_by_title(@params[:query])
                             .pluck(:id)

      relation = relation.where(pelicula_id: pelicula_ids)
      selected_query = {
        "filter_display": @params[:query],
        "filter_value": @params[:query]
      }
      selected_filters[:query] = selected_query
    end

    if @params[:mostra].present?
      selected_mostra = @mostras_filter.find { |c| c["permalink_pt"] == @params[:mostra] }
      selected_filters[:mostra] = selected_mostra if selected_mostra

      if selected_mostra
        relation = relation.where(mostras: { permalink_pt: selected_filters[:mostra]["permalink_pt"] })
      end
    end

    if @params[:cinema]
      selected_cinema = @cinemas_filter.find do |cinema_filter|
        (cinema_filter["id"].to_s == @params[:cinema].to_s) && (cinema_filter["edicao_id"] == @edicao_id)
      end
      if selected_cinema
        selected_filters[:cinema] = selected_cinema
        relation = relation.where(cinema_id: selected_cinema["id"])
      end
    end

    if @params[:pais]
      selected_pais = @paises_filter.find do |pais_filter|
        (pais_filter["id"].to_s == @params[:pais].to_s)
      end
      if selected_pais
        selected_filters[:pais] = selected_pais
        relation = relation.joins(pelicula: :paises).where(pelicula: { paises: { id: selected_pais["id"] } })
      end
    end

    if @params[:sessao].present?
      selected_sessao = @sessoes.find { |sessao| (sessao["filter_value"] == @params[:sessao]) }

      if selected_sessao
        selected_filters[:sessao] = selected_sessao
        relation = relation.where(sessao: @params[:sessao]..)
      end
    end

    if @params[:genero].present?
      selected_genre = @genres_filter.find { |genre| (genre["filter_value"] == @params[:genero]) }

      if selected_genre
        selected_filters[:genero] = selected_genre
        pelicula_ids = Pelicula.where(edicao_id: @edicao_id).search_by_genre(selected_genre["filter_value"]).pluck(:id)
        relation = relation.where(pelicula_id: pelicula_ids)
      end
    end

    if @params[:direcao].present?
      selected_director = @directors_filter.find { |d| d["filter_value"] == @params[:direcao] }

      if selected_director
        selected_filters[:direcao] = selected_director

        pelicula_ids = Pelicula.where(edicao_id: @edicao_id)
                              .where(diretor_coord_int: selected_director["filter_value"])
                              .pluck(:id)

        relation = relation.where(pelicula_id: pelicula_ids)
      end
    end

    if @params[:elenco].present?
      actor_query = @params[:elenco]
      pelicula_ids = @pelicula_collection_service.actor_to_pelicula_mapping(@edicao_id)[actor_query] || []
      if pelicula_ids.any?
        selected_actor = {
          "filter_display" => actor_query,
          "filter_value" => actor_query,
          "filter_label" => I18n.t("filter.elenco")
        }
        selected_filters[:elenco] = selected_actor
        relation = relation.where(pelicula_id: pelicula_ids)
      end
    end

    available_dates = relation.distinct.pluck(:data).sort
    selected_date = available_dates.first

    if @params[:date].present?
      parsed_date = Date.parse(@params[:date]) rescue nil
      if parsed_date&.in?(available_dates)
        selected_date = parsed_date
      end
    end
    selected_filters[:date] = selected_date

    Result.new(
      relation: relation,
      selected_filters: selected_filters,
      selected_query: selected_query,
      selected_mostra: selected_mostra,
      selected_cinema: selected_cinema,
      selected_pais: selected_pais,
      selected_sessao: selected_sessao,
      selected_genre: selected_genre,
      selected_director: selected_director,
      selected_actor: selected_actor,
      selected_date: selected_date,
      available_dates: available_dates
    )
  end
end
