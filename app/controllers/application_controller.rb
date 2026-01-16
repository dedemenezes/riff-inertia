class ApplicationController < ActionController::Base
  before_action :set_locale, :set_root_url, :current_edicao

  inertia_share flash: -> {
    {
      success: flash[:success],
      error: flash[:error]
    }
  }

  inertia_share currentLocale: -> {
    I18n.locale.to_s
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

  def current_edicao
    @current_edicao = Edicao.find_by!(descricao: ApplicationRecord::EDICAO_ATUAL_ANO)
  end

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
        { name: I18n.t("navigation.programming.with_guests"), path: "" },
        { name: I18n.t("navigation.programming.free"), path: "" },
        { name: I18n.t("navigation.programming.updates"), path: "" }
      ],
      I18n.t("navigation.edition.name", edicao_atual: ApplicationRecord::EDICAO_ATUAL_ANO) => [
        { name: "Todos os filmes", path: peliculas_path },
        { name: "Mostras", path: mostras_path },
        { name: "Cinemas", path: cinemas_path },
        { name: "Júri", path: "" },
        { name: "Equipe", path: "" }
      ],
      I18n.t("navigation.about.name") => [
        { name: "O Festival", path: "" },
        { name: "Edições Anteriores", path: edicoes_anteriores_path },
        { name: "Talent Press", path: "" },
        { name: "Parceiros", path: "" }
      ],
      I18n.t("navigation.articles.name") => [
        { name: "Todas as notícias", path: noticias_path }
      ],
      I18n.t("navigation.media.name") => [
        { name: "Fotos e vídeos", path: "" },
        { name: "Impressos", path: "" }
      ]
    }
  end

  def set_menu_context
    {
      "programacao" => [
        { name: "Programação", path: program_url, icon: "program" },
        { name: "Sessões com convidados", path: "", icon: "newUser" },
        { name: "Mudanças na Programação", path: "", icon: "change" },
        { name: "Programação Gratuita", path: "", icon: "ticket" }
      ],
      "edicao" => [
        { name: "Todos os Filmes", path: peliculas_path, icon: "program" },
        { name: "Mostras", path: mostras_path, icon: "grid" },
        { name: "Cinemas", path: cinemas_path, icon: "pin" },
        { name: "Juri", path: "", icon: "trophy" },
        { name: "Equipe", path: "", icon: "people" }
      ],
      "sobre" => [
        { name: "O Festival", path: "", icon: "logoFest" },
        { name: "Edições Anteriores", path: edicoes_anteriores_url, icon: "calendar" },
        { name: "Talent Rio", path: "", icon: "talentPress" },
        { name: "Parceiros", path: "", icon: "handshake" }
      ],
      "midias" => [
        { name: "Fotos & Vídeos", path: "", icon: "image" },
        { name: "Impressos", path: "", icon: "book" }
      ]
    }
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
