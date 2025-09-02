class PagesController < ApplicationController
  def home
    # Gather data
    mainItems = [
      I18n.t("navigation.programming"),
      I18n.t("navigation.edition2024"),
      I18n.t("navigation.aboutUs"),
      I18n.t("navigation.news"),
      I18n.t("navigation.media"),
      I18n.t("navigation.information")
    ]

    secondaryItems = [
      { name: I18n.t("navigation.press"), tag: "a", href: root_url },
      { name: I18n.t("navigation.archive"), tag: "a", href: "https://www.globo.com" },
      { name: I18n.t("navigation.registrations"), tag: "a", href: root_url },
      { name: I18n.t("navigation.contact"), tag: "a", href: root_url }
    ]
    quickLinksConfig = [
      {
        id: 1,
        title: "Programação",
        description: "Veja a programação completa ou filtre de acordo com o que deseja.",
        href: program_url
      },
      {
        id: 2,
        title: "Tickets",
        description: "Descubra como garantir sua entrada nos cinemas e eventos.",
        href: root_url
      },
      {
        id: 3,
        title: "Agenda",
        description: "Planeje-se verificando as mudanças na programação.",
        href: root_url
      }
    ]

    noticias = Noticia
              .includes(:caderno)
              .last(6)
              .as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ]
              )
    # root_url = request.base_url
    render inertia: "HomePage", props: {
      rootUrl: @root_url,
      quickLinksConfig:,
      mainItems:,
      secondaryItems:,
      noticias:
    }
  end
end
