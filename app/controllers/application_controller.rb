class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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
          path: ""
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
          path: ""
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
          path: ""
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
end
