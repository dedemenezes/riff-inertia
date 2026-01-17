module ProgramFilterOptions
  extend ActiveSupport::Concern
  def set_filter_options(base_scope)
    @paises_filter   = build_paises_filter(base_scope)

    @mostras_filter  = build_mostra_filter
    @cinemas_filter = build_cinema_filter

    @sessoes = build_sessoes_filter

    @genres_filter = @pelicula_collection_service.collection_for_genres
    @directors_filter = @pelicula_collection_service.collection_for_directors
    @actors_filter = @pelicula_collection_service.collection_for_actors
  end

  def build_sessoes_filter
    Programacao.where(edicao_id: @current_edicao)
               .to_a
               .uniq { |p| p.sessao }
               .sort_by { |it| it.sessao }
               .as_json(
                 only: %i[sessao],
                 methods: %i[display_sessao filter_value filter_display filter_label]
               )
  end

  def build_paises_filter(base_scope)
    @paises_filter = base_scope.includes(pelicula: :paises)
                               .map { _1.pelicula.paises }
                               .flatten
                               .uniq
                               .sort_by { |it| it.nome_pais }
                               .as_json(
                                 only: %i[id nome_pais],
                                 methods: %i[filter_display filter_value filter_label]
                               )
  end

  def build_cinema_filter
    Cinema.where(edicao_id: @current_edicao)
          .to_a
          .uniq { |m| m.id }
          .sort_by { |it| it.nome }
          .as_json(
            only: %i[id nome endereco edicao_id],
            methods: %i[filter_display filter_value filter_label]
          )
  end

  def build_mostra_filter
    Mostra.where(edicao_id: @current_edicao)
          .to_a
          .uniq { |mostra| mostra.id }
          .sort_by { |mostra| mostra.permalink_pt }
          .as_json(
            only: %i[id permalink_pt nome_abreviado],
            methods: [ :tag_class, :display_name, :filter_value, :filter_display, :filter_label ]
          )
  end

  def set_pelicula_collection_service
    @pelicula_collection_service = PeliculaCollectionService.new
  end
end
