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

  inertia_share imprensaPath: -> { imprensa_page ? imprensa_path : nil }

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
        { name: I18n.t("navigation.juri"), path: festival_juri_path(locale: I18n.locale) },
        { name: I18n.t("navigation.edition.team"), path: equipe_path(locale: I18n.locale) }
      ],
      I18n.t("navigation.festival.name") => [
        { name: I18n.t("navigation.about.name"), path: festival_sobre_nos_path },
        { name: I18n.t("navigation.edicoes_anteriores"), path: edicoes_anteriores_path },
        { name: I18n.t("navigation.talent_press"), path: talents_members_path },
        { name: I18n.t("navigation.parceiros"), path: festival_parceiros_path }
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
    current_session_type = params[:tipo_sessao].presence

    {
      "programacao" => [
        { name: I18n.t("navigation.programming.name"), path: program_path, icon: "program", active: current_session_type.blank? },
        { name: I18n.t("navigation.programming.special"), path: program_path(tipo_sessao: "especial"), icon: "star", active: current_session_type == "especial" },
        { name: I18n.t("navigation.programming.with_gratuity"), path: program_path(tipo_sessao: "gratuidade"), icon: "ticket", active: current_session_type == "gratuidade" },
        { name: I18n.t("navigation.programming.with_debates"), path: program_path(tipo_sessao: "debate"), icon: "chatDots", active: current_session_type == "debate" },
        { name: I18n.t("navigation.mudancas_na_programacao"), path: "", icon: "change", active: false }
      ],
      "edicao" => [
        { name: I18n.t("navigation.todos_os_filmes"), path: peliculas_path, icon: "program" },
        { name: I18n.t("navigation.mostras"), path: mostras_path, icon: "grid" },
        { name: I18n.t("navigation.cinemas"), path: cinemas_path, icon: "pin" },
        { name: I18n.t("navigation.juri"), path: festival_juri_path(locale: I18n.locale), icon: "trophy" },
        { name: I18n.t("navigation.edition.team"), path: equipe_path(locale: I18n.locale), icon: "people" }
      ],
      "sobre" => [
        { name: I18n.t("navigation.about.name"), path: festival_sobre_nos_path, icon: "logoFest" },
        { name: I18n.t("navigation.edicoes_anteriores"), path: edicoes_anteriores_url, icon: "calendar" },
        { name: I18n.t("navigation.talent_rio"), path: talents_members_path, icon: "talentPress" },
        { name: I18n.t("navigation.parceiros"), path: festival_parceiros_path, icon: "handshake" }
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
      { name: I18n.t("navigation.mostras"), path: edicao_anterior_mostras_path(edicao), icon: "grid" },
      { name: I18n.t("navigation.todos_os_filmes"), path: edicao_anterior_filmes_path(edicao), icon: "film" },
      { name: I18n.t("navigation.todas_as_noticias"), path: edicao_anterior_noticias_path(edicao), icon: "newspaper" },
      { name: I18n.t("navigation.juri"), path: "#", icon: "trophy" }
    ]
  end

  def set_secondary_items
    items = [
      { name: I18n.t("navigation.tickets"), tag: "a", href: ingressos_como_comprar_path, internal: true }
    ]

    if imprensa_page
      items << { name: I18n.t("navigation.press"), tag: "a", href: imprensa_path, internal: true }
    end

    items.concat([
      { name: I18n.t("navigation.registrations"), tag: "a", href: root_url },
      { name: I18n.t("navigation.contact"), tag: "a", href: root_url }
    ])
  end

  private

  # Memoized per request: shared by the secondary nav and the footer link.
  # Returns nil when the current locale has no legacy content.
  def imprensa_page
    return @imprensa_page if defined?(@imprensa_page)

    @imprensa_page = ImprensaPage.for(I18n.locale)
  end
end
