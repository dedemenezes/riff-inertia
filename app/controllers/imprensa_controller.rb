# frozen_string_literal: true

class ImprensaController < ApplicationController
  def index
    pagina = imprensa_page
    raise ActiveRecord::RecordNotFound unless pagina

    render inertia: "Imprensa/Index", props: {
      titulo: pagina.titulo,
      conteudo: sanitized_legacy_content(pagina.conteudo)
    }
  end

  private

  # NOTE: duplicado de IngressosController#sanitized_legacy_content de propósito.
  # Extração de um concern/serviço compartilhado fica para uma task/branch separada.
  def sanitized_legacy_content(html)
    fragment = Nokogiri::HTML::DocumentFragment.parse(html.to_s)
    fragment.css("script, style").remove

    helpers.sanitize(fragment.to_html)
  end
end
