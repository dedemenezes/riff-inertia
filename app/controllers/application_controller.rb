class ApplicationController < ActionController::Base
  before_action :set_locale, :set_root_url

  inertia_share flash: -> {
    {
      success: flash[:success],
      error: flash[:error]
    }
  }

  inertia_share currentLocale: -> {
    I18n.locale.to_s
  }
  inertia_share locale_messages: -> {
    FrontendLocaleMessages.as_json_hash
  }

  inertia_share mainItems: -> {
    set_main_items
  }

  inertia_share secondaryItems: -> {
    set_secondary_items
  }

  inertia_share menuContext: -> {
    set_menu_context
  }

  inertia_share imageBaseURL: -> {
    ENV.fetch("IMAGES_BASE_URL", "DEFINE_BASE_URL_AT_ENV_FILE")
  }

  inertia_share rootUrl: -> { @root_url }

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_root_url
    @root_url = "#{request.base_url}/#{I18n.locale}"
  end

  def set_main_items
    {
      I18n.t("navigation.programming.name") => [
        { name: I18n.t("navigation.programming.full_schedule"), path: program_path },
        { name: I18n.t("navigation.programming.with_guests"), path: program_path(free: true) },
        { name: I18n.t("navigation.programming.free"), path: "" },
        { name: I18n.t("navigation.programming.updates"), path: "" }
      ],
      I18n.t("navigation.edition.name", edicao_atual: Edicao.current.descricao) => [
        { name: I18n.t("navigation.todos_os_filmes"), path: peliculas_path },
        { name: I18n.t("navigation.mostras"), path: mostras_path },
        { name: I18n.t("navigation.cinemas"), path: cinemas_path },
        { name: I18n.t("navigation.juri"), path: "" },
        { name: I18n.t("navigation.edition.team"), path: equipe_path(locale: I18n.locale) }
      ],
      I18n.t("navigation.festival.name") => [
        { name: I18n.t("navigation.about.name"), path: festival_sobre_nos_path },
        { name: I18n.t("navigation.edicoes_anteriores"), path: edicoes_anteriores_path },
        { name: I18n.t("navigation.talent_press"), path: talents_members_path },
        { name: I18n.t("navigation.parceiros"), path: "" }
      ],
      I18n.t("navigation.articles.name") => [
        { name: I18n.t("navigation.todas_as_noticias"), path: noticias_path }
      ],
      I18n.t("navigation.media.name") => [
        { name: I18n.t("navigation.media.fotos_e_videos"), path: "" },
        { name: I18n.t("navigation.media.impressos"), path: "" }
      ]
    }
  end

  def set_menu_context
    {
      "programacao" => [
        { name: I18n.t("navigation.programming.name"), path: program_url, icon: "program" },
        { name: I18n.t("navigation.programming.with_guests"), path: "", icon: "newUser" },
        { name: I18n.t("navigation.mudancas_na_programacao"), path: "", icon: "change" },
        { name: I18n.t("navigation.programming.free"), path: "", icon: "ticket" }
      ],
      "edicao" => [
        { name: I18n.t("navigation.todos_os_filmes"), path: peliculas_path, icon: "program" },
        { name: I18n.t("navigation.mostras"), path: mostras_path, icon: "grid" },
        { name: I18n.t("navigation.cinemas"), path: cinemas_path, icon: "pin" },
        { name: I18n.t("navigation.juri"), path: "", icon: "trophy" },
        { name: I18n.t("navigation.edition.team"), path: equipe_path(locale: I18n.locale), icon: "people" }
      ],
      "sobre" => [
        { name: I18n.t("navigation.about.name"), path: festival_sobre_nos_path, icon: "logoFest" },
        { name: I18n.t("navigation.edicoes_anteriores"), path: edicoes_anteriores_url, icon: "calendar" },
        { name: I18n.t("navigation.talent_rio"), path: talents_members_path, icon: "talentPress" },
        { name: I18n.t("navigation.parceiros"), path: "", icon: "handshake" }
      ],
      "midias" => [
        { name: I18n.t("navigation.media.fotos_e_videos"), path: "", icon: "image" },
        { name: I18n.t("navigation.media.impressos"), path: "", icon: "book" }
      ],
      "edicoes_anteriores" => []
    }
  end

  def edicoes_anteriores_menu_context(edicao)
    [
      { name: "Mostras", path: edicao_anterior_mostras_path(edicao), icon: "grid" },
      { name: "Filmes", path: edicao_anterior_filmes_path(edicao), icon: "film" },
      { name: "Notícias", path: edicao_anterior_noticias_path(edicao), icon: "newspaper" },
      { name: "Júri/Premiados", path: "#", icon: "trophy" }
    ]
  end

  def set_secondary_items
    [
      { name: I18n.t("navigation.press"), tag: "a", href: root_url },
      { name: I18n.t("navigation.archive"), tag: "a", href: "https://www.globo.com" },
      { name: I18n.t("navigation.registrations"), tag: "a", href: root_url },
      { name: I18n.t("navigation.contact"), tag: "a", href: root_url }
    ]
  end
end
