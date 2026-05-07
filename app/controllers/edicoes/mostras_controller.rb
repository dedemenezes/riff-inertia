class Edicoes::MostrasController < ApplicationController
  include BreadcrumbsHelper
  before_action :set_edicao

  def index
    ultima_importacao_id = Importacao.where(edicao_id: @edicao.id).order(created: :desc).pick(:id)
    @mostras = Mostra.includes(:peliculas).where(importacao_id: ultima_importacao_id).group_by(&:display_name)

    @categorias = @mostras.map { |categoria, mostras| {
      name: categoria,
      class: mostras.first.tag_class,
      path: mostra_path(categoria),
      mostraImageURL: mostras.first.peliculas.sample&.imageURL
    } }
    render inertia: "Edicoes/Mostras", props: {
      edicao: @edicao.as_json(only: %i[id descricao], methods: %i[cartazURL]),
      categorias: @categorias.as_json,
      menuContext: set_menu_context.merge(
        "edicoes_anteriores" => edicoes_anteriores_menu_context(@edicao)
      ),
      fallBackUrl: edicoes_anteriores_path
    }
  end

  private

  def set_edicao
    @edicao = Edicao.find(params[:edicao_anterior_id])
  end
end
