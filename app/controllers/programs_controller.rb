class ProgramsController < ApplicationController
  include InfiniteScrollable
  DATES_PER_PAGE = 1

  include BreadcrumbsHelper, Pagy::Backend
  include ProgramFilterOptions

  before_action :set_pelicula_collection_service

  def index
    last_import_id = Programacao.maximum(:importacoesprog_id)

    base_scope = Programacao
      .joins(pelicula: :mostra)
      .includes(:cinema, pelicula: :mostra)
      .where(importacoesprog_id: last_import_id, edicao_id: Edicao.current.id, deletado: 0) # TODO: remover importacoes?

    set_filter_options(base_scope)

    filter_result = ProgramacoesFilter.new(
      relation: base_scope,
      params: params,
      filter_options: {
        mostras: @mostras_filter,
        cinemas: @cinemas_filter,
        paises: @paises_filter,
        sessoes: @sessoes,
        genres: @genres_filter,
        directors: @directors_filter
      },
      pelicula_collection_service: @pelicula_collection_service
    ).call

    @selected_filters = filter_result.selected_filters
    @selected_query = filter_result.selected_query
    @selected_mostra = filter_result.selected_mostra
    @selected_cinema = filter_result.selected_cinema
    @selected_pais = filter_result.selected_pais
    @selected_sessao = filter_result.selected_sessao
    @selected_genre = filter_result.selected_genre
    @selected_director = filter_result.selected_director
    @selected_actor = filter_result.selected_actor
    @selected_session_type = filter_result.selected_session_type
    base_scope = filter_result.relation

    programacoes_scope = base_scope.order(:data, :sessao)

    current_page = params[:page].to_i ||= 1

    @pagy, @programacoes = pagy_infinite(programacoes_scope, current_page)

    @programacoes = @programacoes.map do |programacao|
      {
        id: programacao.id,
        data: programacao.data,
        date_label: programacao.display_date,
        sessao: [ programacao.display_sessao ],
        cinema: programacao.cinema&.nome,
        titulo: programacao.pelicula&.titulo_portugues_coord_int,
        duracao: programacao.pelicula&.duracao_coord_int,
        imagem_url: programacao.pelicula&.imageURL,
        genero: programacao.pelicula&.genre,
        paises: programacao.pelicula&.display_paises,
        mostra: programacao.pelicula&.mostra&.display_name,
        mostra_tag_class: programacao.pelicula&.mostra&.tag_class,
        pelicula_url: pelicula_path(programacao.pelicula.permalink),
        gratuito:  ActiveRecord::Type::Boolean.new.cast(programacao.gratuito)
      }
    end

    # Build breadcrumbs
    render inertia: "ProgramPage", props: {
      tabBaseUrl: program_url,
      elements: @programacoes,
      pagy: @pagy,
      mostras: @mostras_filter,
      cinemas: @cinemas_filter,
      paises: @paises_filter,
      genres: @genres_filter,
      sessoes: @sessoes,
      directors: @directors_filter,
      actors: @actors_filter,
      session_type_nav: session_type_nav(@selected_session_type),
      current_filters: { # those are the ones used as modelValue
        query: @selected_query,
        mostra: @selected_mostra,
        cinema: @selected_cinema,
        pais: @selected_pais,
        genero: @selected_genre,
        sessao: @selected_sessao,
        elenco: @selected_actor,
        direcao: @selected_director
      },
      current_session_type: @selected_session_type,
      has_active_filters: params.permit(:query, :mostra).to_h.values.any?(&:present?),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ "Programação", "" ],
        [ "Programação Completa", "" ],
      ),
      endMessage: I18n.t("infinite_scroll.end.sessoes")
    }
  end

  private

  def session_type_nav(current_session_type)
    [
      {
        label: I18n.t("navigation.programming.name"),
        href: program_path,
        icon: "program",
        session_type: nil,
        active: current_session_type.blank?
      },
      {
        label: I18n.t("navigation.programming.special"),
        href: program_path(tipo_sessao: "especial"),
        icon: "star",
        session_type: "especial",
        active: current_session_type == "especial"
      },
      {
        label: I18n.t("navigation.programming.with_gratuity"),
        href: program_path(tipo_sessao: "gratuidade"),
        icon: "ticket",
        session_type: "gratuidade",
        active: current_session_type == "gratuidade"
      },
      {
        label: I18n.t("navigation.programming.with_debates"),
        href: program_path(tipo_sessao: "debate"),
        icon: "chatDots",
        session_type: "debate",
        active: current_session_type == "debate"
      }
    ]
  end
end
