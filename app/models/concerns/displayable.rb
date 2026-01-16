module Displayable
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  def display_titulo
    I18n.locale == :pt ? titulo_portugues_coord_int : titulo_ingles_coord_int
  end

  def display_sinopse
    I18n.locale == :pt ? sinopse_port_export : sinopse_ing_export
  end

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

  def display_sobre_o_filme
    I18n.t("pelicula.sobre_o_filme")
  end

  def displayTeamsHeader
    I18n.t("pelicula.diretor")
  end
end
