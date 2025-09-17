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

    # TODO: Refac move to service
    # TODO: Rails Cache
    # Get youtube videos from Festival do Rio
    playlist_response = HTTParty.get("#{ENV.fetch("YT_BASE_URL")}/playlistItems", {
      query: {
        part: "snippet",
        playlistId: ENV.fetch("YT_CHANNEL_ID"),  # Use the correct one from step 2
          maxResults: 5,
        key: ENV.fetch("YT_API_KEY")
      }
    })

    # Get next programacoes
    @programacoes = Programacao
    .where(edicao_id: 12)
    .where("TIME(sessao) > ? AND TIME(sessao) < ?", Time.now.strftime("%H:%M:%S"), Time.now.end_of_day.strftime("%H:%M:%S"))
    .order([ :data, :sessao ])
    .limit(9)

    @programacoes.includes(:cinema, pelicula: :mostra)
    @programacoes = @programacoes.map do |programacao|
      {
        id: programacao.id,
        data: programacao.data,
        sessao: [ programacao.display_sessao ],
        cinema: programacao.cinema&.nome,
        titulo: programacao.pelicula&.titulo_portugues_coord_int,
        duracao: programacao.pelicula&.duracao_coord_int,
        imagem: programacao.pelicula&.imagem,
        genero: programacao.pelicula&.genre,
        paises: programacao.pelicula&.display_paises,
        mostra: programacao.pelicula&.mostra&.display_name,
        mostra_tag_class: programacao.pelicula&.mostra&.tag_class,
        pelicula_url: pelicula_path(programacao.pelicula.permalink)
      }
    end

    webdoors = Webdoor.ordered.as_json(
      only: %i[ id titulo ],
      methods: %i[ permalink mobile_image_url desktop_image_url ]
    )

    render inertia: "HomePage", props: {
      rootUrl: @root_url,
      quickLinksConfig:,
      noticias:,
      noticasUrl: noticias_url,
      youtubeVideos: playlist_response["items"],
      nextSessions: @programacoes,
      webdoors:
    }
  end
end
