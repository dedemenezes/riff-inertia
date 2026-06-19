class TalentsController < ApplicationController
  include BreadcrumbsHelper

  TALENTS_CADERNO_PERMALINK = {
    pt: "talents-rio",
    en: "talents-rio"
  }.freeze

  def participants
    @pagina = Pagina.find_by(rota: "/br/talents/", permalink: :apresentacao)

    render inertia: "Talents/Apresentacao", props: {
      crumbs: talents_crumbs,
      sections: TalentsContentParser.parse(@pagina&.conteudo),
      tabs: TalentsTabs.build(active: "sobre")
    }
  end

  def programacao
    @pagina = Pagina.find_by(rota: "/br/talents/", permalink: :programacao)

    render inertia: "Talents/Programacao", props: {
      crumbs: talents_crumbs,
      sections: TalentsProgramacaoParser.parse(@pagina&.conteudo),
      tabs: TalentsTabs.build(active: "programacao")
    }
  end

  def news
    idioma = Idioma.find_by("locale LIKE ?", "#{I18n.locale}%")
    permalink = TALENTS_CADERNO_PERMALINK[I18n.locale.to_sym] || TALENTS_CADERNO_PERMALINK[:pt]
    permalink_column = I18n.locale == :pt ? :permalink_pt : :permalink_en

    noticias = Noticia
      .includes(:caderno)
      .where(idioma: idioma)
      .published
      .joins(:caderno)
      .where(cadernos: { permalink_column => permalink })
      .order(created: :desc)

    render inertia: "Talents/NoticiasECriticas", props: {
      crumbs: talents_crumbs,
      tabs: TalentsTabs.build(active: "noticias_e_criticas"),
      noticias: noticias.map { |noticia|
        noticia.listing_as_json(
          only: %i[id permalink chamada],
          methods: [ :caderno_nome, :display_date, :image_url ]
        )
      }
    }
  end

  private

  def talents_crumbs
    breadcrumbs(
      [ "", @root_url ],
      [ I18n.t("navigation.festival.name"), "#" ],
      [ I18n.t("navigation.talent_rio"), talents_members_path ]
    )
  end
end
