class ProgramsController < ApplicationController
  include Pagy::Backend

  def index
    text = I18n.t("hello")
    items = [
      # Links tem que vir do controller para incluir localizacao. Textos também
      { name: I18n.t("navigation.programming"), route: program_url, icon: "program" },
      { name: I18n.t("navigation.sessoes_com_convidados"), route: "/", icon: "user" },
      { name: I18n.t("navigation.mudancas_na_programacao"), route: "/", icon: "change" },
      { name: I18n.t("navigation.sessoes_ao_ar_livre"), route: "/", icon: "clock" }
    ]

    last_import_id = Programacao.maximum(:importacoesprog_id)
    base_scope = Programacao
      .includes(:cinema, pelicula: :mostra)
      .where(importacoesprog_id: last_import_id)
      .order(:data, :sessao)

    @pagy, @programacoes = pagy_infinite(base_scope, params[:page])
    # @programacoes_by_date = @programacoes.group_by(&:data)

    @programacoes = @programacoes.map do |p|
      {
        id: p.id,
        data: p.data,
        sessao: [ p.display_sessao ],
        cinema: p.cinema&.nome,
        titulo: p.pelicula&.titulo_portugues_coord_int,
        duracao: p.pelicula&.duracao_coord_int,
        imagem: p.pelicula&.imagem,
        genero: p.pelicula&.genre,
        mostra: p.pelicula&.mostra&.nome_abreviado,
        mostra_tag_class: p.pelicula&.mostra&.tag_class
      }
    end

    render inertia: "ProgramPage", props: {
      rootUrl: @root_url,
      items:,
      elements: @programacoes,
      pagy: {
        page: @pagy.page,
        pages: @pagy.pages,
        last: @pagy.last
      }
    }
  end

  private

  # TODO: Relocate this piece into a concern or helper
  def pagy_infinite(collection, page_param)
    current_page = (page_param || params[:page] || 1).to_i
    limit = Pagy::DEFAULT[:limit] || 20

    if current_page <= 1
      # First page - normal pagination
      pagy_result = pagy(collection, limit: limit)
      pagy_result
    else
      # Infinite scroll - load all items from page 1 to current page
      total_items_needed = current_page * limit

      # Get the actual items
      items = collection.limit(total_items_needed)

      # Create proper pagy object with
      # all the metadata need in the frontend
      total_count = collection.count
      pagy_obj = Pagy.new(
        count: total_count,
        limit: limit,
        page: current_page
      )

      [ pagy_obj, items ]
    end
  end
end
