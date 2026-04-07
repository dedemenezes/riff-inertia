# frozen_string_literal: true

class EquipeController < ApplicationController
  include BreadcrumbsHelper

  def index
    render inertia: "Equipe/Index", props: {
      rootUrl: @root_url,
      crumbs: breadcrumbs(
        [ "", @root_url ],
        [ I18n.t("navigation.edition.name", edicao_atual: ApplicationRecord::EDICAO_ATUAL_ANO), peliculas_path ],
        [ I18n.t("navigation.edition.team"), equipe_path(locale: I18n.locale) ]
      ),
      **EquipePageContent.as_props
    }
  end
end
