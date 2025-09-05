class PagesController < ApplicationController
  def home
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
              .published
              .includes(:caderno)
              .order(created: :desc)
              .limit(6)
              .as_json(
                only: %i[id titulo permalink chamada imagem],
                methods: [ :caderno_nome, :display_date ],
              )
    # root_url = request.base_url
    render inertia: "HomePage", props: {
      rootUrl: @root_url,
      quickLinksConfig:,
      noticias:,
      noticasUrl: noticias_url
    }
  end
end
