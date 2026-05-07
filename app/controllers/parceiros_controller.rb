# frozen_string_literal: true

class ParceirosController < ApplicationController
  include BreadcrumbsHelper

  def index
    render inertia: "Parceiros/Index", props: {
      crumbs: parceiros_crumbs,
      tabs: ParceirosTabs.build(active: "parceiros")
    }
  end

  def editoriais
    render inertia: "Parceiros/Editoriais", props: {
      crumbs: parceiros_crumbs,
      tabs: ParceirosTabs.build(active: "editoriais")
    }
  end

  private

  def parceiros_crumbs
    breadcrumbs(
      [ I18n.t("navigation.home"), @root_url ],
      [ I18n.t("navigation.festival.name"), "#" ],
      [ I18n.t("navigation.parceiros"), festival_parceiros_path ]
    )
  end
end
