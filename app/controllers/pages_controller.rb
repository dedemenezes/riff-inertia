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

    # Get youtube videos from Festival do Rio
    playlist_response = HTTParty.get("#{ENV.fetch("YT_BASE_URL")}/playlistItems", {
      query: {
        part: "snippet",
        playlistId: ENV.fetch("YT_CHANNEL_ID"),  # Use the correct one from step 2
          maxResults: 5,
        key: ENV.fetch("YT_API_KEY")
      }
    })

    render inertia: "HomePage", props: {
      rootUrl: @root_url,
      quickLinksConfig:,
      noticias:,
      noticasUrl: noticias_url,
      youtubeVideos: playlist_response["items"]
    }
  end
end
