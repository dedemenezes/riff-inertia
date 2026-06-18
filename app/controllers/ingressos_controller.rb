# frozen_string_literal: true

class IngressosController < ApplicationController
  include BreadcrumbsHelper

  LEGACY_ROUTES = {
    pt: "/br/ingressos/",
    en: "/en/tickets/"
  }.freeze

  FALLBACK_LEGACY_ROUTE = "/br/ingressos/"

  def index
    redirect_to ingressos_como_comprar_path
  end

  def como_comprar
    render_content_page(active: "como_comprar", permalink: "como-e-onde-comprar")
  end

  def pacotes
    render_content_page(active: "pacotes", permalink: "pacotes")
  end

  def proximas_sessoes
    render inertia: "Ingressos/ProximasSessoes", props: base_props("proximas_sessoes").merge(
      titulo: I18n.t("ingressos.tabs.proximas_sessoes"),
      descricao: I18n.t("ingressos.proximas_sessoes.descricao"),
      cta: I18n.t("ingressos.proximas_sessoes.cta"),
      programPath: program_path
    )
  end

  private

  def render_content_page(active:, permalink:)
    pagina = find_legacy_page(permalink)

    render inertia: "Ingressos/Conteudo", props: base_props(active).merge(
      titulo: pagina&.titulo || I18n.t("ingressos.tabs.#{active}"),
      conteudo: sanitized_legacy_content(pagina&.conteudo)
    )
  end

  def sanitized_legacy_content(html)
    fragment = Nokogiri::HTML::DocumentFragment.parse(html.to_s)
    fragment.css("script, style").remove

    helpers.sanitize(fragment.to_html)
  end

  def base_props(active)
    {
      tabs: IngressosTabs.build(active: active)
    }
  end

  def find_legacy_page(permalink)
    Pagina.find_by(rota: legacy_route, permalink: permalink) ||
      Pagina.find_by(rota: FALLBACK_LEGACY_ROUTE, permalink: permalink)
  end

  def legacy_route
    LEGACY_ROUTES.fetch(I18n.locale.to_sym, FALLBACK_LEGACY_ROUTE)
  end
end
