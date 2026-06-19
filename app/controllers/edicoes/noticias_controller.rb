class Edicoes::NoticiasController < ApplicationController
  include Pagy::Backend
  include InfiniteScrollable

  PER_PAGE = 9
  NEWS_COLUMNS = %i[id permalink chamada].freeze
  NEWS_METHODS = %i[caderno_nome display_date image_url].freeze

  before_action :set_edicao

  def index
    idioma = Idioma.find_by("locale LIKE ?", "#{I18n.locale}%")
    base_scope = Noticia.includes(:caderno)
                       .where(idioma: idioma)
                       .published
                       .where(data: @edicao.data_inicio..@edicao.data_termino)

    filter_result = NoticiasFilter.new(
      relation: base_scope,
      params: params,
      locale: I18n.locale,
      cadernos_relation: Caderno.where(id: base_scope.select(:caderno_id)),
      date_mode: :exact
    ).call

    filtered_relation = filter_result.relation.order(titulo: sort_direction)
    current_page = [ params[:page].to_i, 1 ].max
    @pagy, @noticias = pagy_infinite(filtered_relation, current_page, PER_PAGE)

    render inertia: "Edicoes/Noticias", props: {
      edicao: @edicao.as_json(only: %i[id descricao], methods: %i[cartazURL]),
      elements: @noticias.map { |noticia|
        noticia.listing_as_json(
          only: NEWS_COLUMNS,
          methods: NEWS_METHODS
        )
      },
      pagy: {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      },
      cadernos: filter_result.cadernos,
      current_filters: {
        query: filter_result.selected_query,
        data: filter_result.selected_date,
        caderno: filter_result.selected_caderno
      },
      has_active_filters: params.permit(:query, :data, :caderno).to_h.values.any?(&:present?),
      sort: sort_direction.to_s,
      tabBaseUrl: edicao_anterior_noticias_path(@edicao),
      fallBackUrl: edicoes_anteriores_path,
      endMessage: I18n.t("infinite_scroll.end.noticias"),
      dataLabel: I18n.t("filter.date"),
      activePage: I18n.t("navigation.todas_as_noticias"),
      menuContext: set_menu_context.merge(
        "edicoes_anteriores" => edicoes_anteriores_menu_context(@edicao)
      )
    }
  end

  private

  def set_edicao
    @edicao = Edicao.find(params[:edicao_anterior_id])
  end

  def sort_direction
    params[:sort] == "desc" ? :desc : :asc
  end
end
