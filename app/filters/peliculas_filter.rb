# frozen_string_literal: true

# Applies pelicula listing filters from request params to a Pelicula relation
# and builds selected filter state for Inertia props.
class PeliculasFilter
  Result = Struct.new(
    :relation,
    :selected_filters,
    :selected_query,
    :selected_mostra,
    :selected_pais,
    :selected_genre,
    :selected_director,
    :selected_actor,
    keyword_init: true
  )

  def initialize(relation:, params:, filter_options:, pelicula_collection_service:, edicao_id: Edicao.current.id)
    @relation = relation
    @params = params
    @edicao_id = edicao_id
    @mostras_filter = filter_options.fetch(:mostras)
    @paises_filter = filter_options.fetch(:paises)
    @genres_filter = filter_options.fetch(:genres)
    @directors_filter = filter_options.fetch(:directors)
    @pelicula_collection_service = pelicula_collection_service
  end

  def call
    relation = @relation
    selected_filters = {}
    selected_query = nil
    selected_mostra = nil
    selected_pais = nil
    selected_genre = nil
    selected_director = nil
    selected_actor = nil

    if @params[:query].present?
      relation = relation.search_by_title(@params[:query])
      selected_query = {
        "filter_display" => @params[:query],
        "filter_value" => @params[:query],
        "filter_label" => I18n.t("filter.busca")
      }
      selected_filters[:query] = selected_query
    end

    if @params[:mostra].present?
      selected_mostra = @mostras_filter.find { |m| m["filter_value"] == @params[:mostra] }
      if selected_mostra
        selected_filters[:mostra] = selected_mostra
        relation = relation.where(mostra_id: selected_mostra["id"])
      end
    end

    if @params[:pais].present?
      selected_pais = @paises_filter.find { |p| p["id"].to_s == @params[:pais].to_s }
      if selected_pais
        selected_filters[:pais] = selected_pais
        relation = relation.joins(:paises).where(paises: { id: selected_pais["id"] })
      end
    end

    if @params[:genero].present?
      selected_genre = @genres_filter.find { |g| g["filter_value"].to_s == @params[:genero].to_s }
      if selected_genre
        selected_filters[:genero] = selected_genre
        relation = relation.where(genero_id: selected_genre["id"])
      end
    end

    if @params[:direcao].present?
      selected_director = @directors_filter.find { |d| d["filter_value"] == @params[:direcao] }
      if selected_director
        selected_filters[:direcao] = selected_director
        relation = relation.where(diretor_coord_int: selected_director["filter_value"])
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
        relation = relation.where(id: pelicula_ids)
      end
    end

    Result.new(
      relation: relation,
      selected_filters: selected_filters,
      selected_query: selected_query,
      selected_mostra: selected_mostra,
      selected_pais: selected_pais,
      selected_genre: selected_genre,
      selected_director: selected_director,
      selected_actor: selected_actor
    )
  end
end
