class PeliculasController < ApplicationController
  include BreadcrumbsHelper

  def show
    @pelicula = Pelicula.find_by(edicao_id: 12, permalink: params[:permalink])
    # @pelicula.as_json(
    #   only: %i[ elenco_coord_int ]
    # )
    columns_needed = %i[
      elenco_coord_int
      edicao_id
      imagem
      titulo_ingles_coord_int
      titulo_portugues_coord_int
      ano_coord_int
      duracao_coord_int
      cor_coord_int
    ]
    render inertia: "Peliculas/Show", props: {
      rootUrl: @root_url,
      pelicula: @pelicula.as_json(
        only: columns_needed,
        methods: %i[
          display_titulo
          imageURL
          display_paises
          genre
          mostra_name
        ]
      ),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.programming"), program_path ],
        [ @pelicula.display_titulo, "" ]
      )
    }
  end
end
