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
      noticias:
    }
  end

  private

  def navbar
    # Gather data
    mainItems = {
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
end
