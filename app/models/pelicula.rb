class Pelicula < ApplicationRecord
  include TeamParseable, Filterable, Displayable, Imageable
  include Rails.application.routes.url_helpers

  CAROUSEL_IMAGES_AMOUNT = 3
  METHODS_NEEDED = %i[
    display_titulo
    display_sinopse
    genre
    display_paises
    displayTeamsHeader
    display_sobre_o_filme
    teams
    imageURL
    posterImageURL
    director_image
    carousel_images
    mostra_name
    mostra_tag_class
    programacoesAsJson
    url
    mostra_display_name
  ]

  COLUMNS_NEEDED = %i[
    elenco_coord_int
    edicao_id
    imagem
    titulo_ingles_coord_int
    titulo_portugues_coord_int
    ano_coord_int
    duracao_coord_int
    cor_coord_int
    catalogo_ficha_2007
    diretor_coord_int
  ]

  belongs_to :importacao
  belongs_to :edicao
  belongs_to :mostra
  has_many :atores_peliculas
  has_many :galerias
  has_many :paises_peliculas
  has_many :paises, through: :paises_peliculas
  has_many :programacoes
  has_many :peliculas_tags


  def programacoesAsJson
    programacoes.order(:data).each_slice(3).map do |programacoes_slice|
      programacoes_slice.map do |prog|
        {
          data: prog.display_date,
          sessao: prog.display_sessao,
          ingresso_url_venda: prog.ingresso_url_venda,
          cinema_name: prog.cinema_name,
          cinema_address: prog.cinema_address
        }
      end
    end
  end

  def mostra_name
    mostra.filter_display
  end

  def mostra_display_name
    mostra.filter_display_name
  end

  def mostra_tag_class
    mostra.tag_class
  end

  def director_image
    return if imagem_diretor.nil? || imagem_diretor.empty?

    imageURL(imagem_diretor)
  end

  def url
    pelicula_path(permalink: self.permalink)
  end
end
