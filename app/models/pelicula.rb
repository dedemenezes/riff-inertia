class Pelicula < ApplicationRecord
  include ActionView::Helpers::TextHelper

  belongs_to :importacao
  belongs_to :edicao
  belongs_to :mostra
  has_many :atores_peliculas
  has_many :galerias
  has_many :paises_peliculas
  has_many :paises, through: :paises_peliculas
  has_many :programacoes
  has_many :peliculas_tags

  def genre
    return "TBD" unless catalogo_ficha_2007

    locales = {
      "pt": 0,
      "en": 1
    }
    catalogo_ficha_2007.split(" ")&.first.split("/")[locales[I18n.locale]] || "TBD"
  end

  def display_paises
    all_paises = paises.map { |it| it.nome_pais }
    # TODO: ORDER HOW?
    counter = all_paises.length
    if counter > 1
      "#{all_paises.first} + #{pluralize(counter - 1, "país", "países")}"
    else
      all_paises.first
    end
  end
end
