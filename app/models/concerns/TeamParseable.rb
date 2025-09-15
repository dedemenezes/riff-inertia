module TeamParseable
  extend ActiveSupport::Concern

  def teams
    {
      I18n.t("pelicula.roteiro") => roteiro_team,
      I18n.t("pelicula.diretor") => diretor_team,
      I18n.t("pelicula.fotografia") => fotografia_team,
      I18n.t("pelicula.producao") => producaoempresa_team,
      I18n.t("pelicula.montagem") => montagem_team
    }
  end

  private

  def diretor_team
    parse_team(diretor_coord_int)
  end

  def fotografia_team
    parse_team(fotografia_coord_int)
  end

  def producaoempresa_team
    parse_team(producaoempresa_coord_int)
  end

  def roteiro_team
    parse_team(roteiro_coord_int)
  end

  def montagem_team
    parse_team(montagem_coord_int)
  end


  def parse_team(field_value)
    return nil if field_value.blank?

    field_value.split(",").map(&:strip)
  end
end
