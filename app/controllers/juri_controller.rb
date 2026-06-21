# frozen_string_literal: true

class JuriController < ApplicationController
  include BreadcrumbsHelper

  LEGACY_ROUTES = {
    pt: "/br/o-festival/",
    en: "/en/the-festival/"
  }.freeze

  def index
    pagina = find_legacy_page
    raise ActiveRecord::RecordNotFound unless pagina

    render inertia: "Juri/Index", props: {
      titulo: pagina.titulo,
      activePage: I18n.t("navigation.juri"),
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition.name", edicao_atual: Edicao.current.descricao), peliculas_path ],
        [ I18n.t("navigation.juri"), festival_juri_path(locale: I18n.locale) ]
      ),
      sections: JuriContentParser.parse(sanitized_legacy_content(pagina.conteudo))
    }
  end

  private

  def find_legacy_page
    rota = LEGACY_ROUTES[I18n.locale.to_sym]
    return nil unless rota

    Pagina.find_by(rota: rota, permalink: %w[juri jury], ativo: true)
  end

  def sanitized_legacy_content(html)
    fragment = Nokogiri::HTML::DocumentFragment.parse(html.to_s)
    fragment.css("script, style").remove

    helpers.sanitize(fragment.to_html)
  end
end
