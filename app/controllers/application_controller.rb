class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

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

  inertia_share mainItems: -> {
    set_main_items
  }

  inertia_share secondaryItems: -> {
    set_secondary_items
  }

  inertia_share menuContext: -> {
    set_menu_context
  }

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
      "Programação": [
        {
          description: "Programação completa",
          path: program_path
        },
        {
          description: "Sessões com convidados",
          path: ""
        },
        {
          description: "Programação gratuita",
          path: ""
        },
        {
          description: "Mudanças na programação",
          path: ""
        }
      ],
      "Edição 2024": [
        {
          description: "Todos os filmes",
          path: ""
        },
        {
          description: "Mostras",
          path: mostras_path
        },
        {
          description: "Cinemas",
          path: ""
        },
        {
          description: "Júri",
          path: ""
        },
        {
          description: "Equipe",
          path: ""
        }
      ],
      "Sobre nós": [
        {
          description: "O Festival",
          path: ""
        },
        {
          description: "Edições Anteriores",
          path: edicoes_anteriores_path
        },
        {
          description: "Talent Press",
          path: ""
        },
        {
          description: "Parceiros",
          path: ""
        }
      ],
      "Notícias": [
        {
          description: "Todas as notícias",
          path: noticias_path
        }
      ],
      "Mídias": [
        {
          description: "Fotos e vídeos",
          path: ""
        },
        {
          description: "Impressos",
          path: ""
        }
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

  def set_menu_context
    {
      "programacao" => [
        { name: "Programação", route: program_url, icon: "program" },
        { name: "Sessões com convidados", route: "/", icon: "newUser" },
        { name: "Mudanças na Programação", route: "/", icon: "change" },
        { name: "Programação Gratuita", route: "/", icon: "ticket" }
      ],
      "edicao" => [
        { name: "Todos os Filmes", route: "/", icon: "program" },
        { name: "Mostras", route: mostras_path, icon: "grid" },
        { name: "Cinemas", route: "/", icon: "pin" },
        { name: "Juri", route: "/", icon: "trophy" },
        { name: "Equipe", route: "/", icon: "people" }
      ],
      "sobre" => [
        { name: "O Festival", route: "/", icon: "logoFest" },
        { name: "Edições Anteriores", route: edicoes_anteriores_url, icon: "calendar" },
        { name: "Talent Press", route: "/", icon: "talentPress" },
        { name: "Parceiros", route: "/", icon: "handshake" }
      ],
      "midias" => [
        { name: "Fotos & Vídeos", route: "/", icon: "image" },
        { name: "Impressos", route: "/", icon: "book" }
      ]
    }
  end
end
