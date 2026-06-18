// @vitest-environment node

import { describe, expect, it } from 'vitest'
import { createInertiaSsrApp } from '../../ssr/create-inertia-app'

const sharedProps = {
  currentLocale: 'pt',
  errors: {},
  flash: {},
  imageBaseURL: 'https://images.example.test',
  locale_messages: {},
  mainItems: {},
  menuContext: {},
  rootUrl: '/pt',
  secondaryItems: [],
}

async function renderPage(component, props, url = '/pt') {
  const page = {
    component,
    props: { ...sharedProps, ...props },
    url,
    version: null,
    encryptHistory: false,
    clearHistory: false,
  }

  const result = await createInertiaSsrApp(page)

  return result.body
}

describe('Inertia SSR entrypoint', () => {
  it('renders the home page main content', async () => {
    const body = await renderPage('HomePage', {
      destaques: [],
      nextSessions: [],
      noticasUrl: '/pt/noticias',
      noticias: [],
      quickLinksConfig: [],
      webdoors: [
        {
          id: 1,
          titulo: 'Festival do Rio SSR',
          desktop_image_url: '/desktop.jpg',
          mobile_image_url: '/mobile.jpg',
        },
      ],
      youtubeVideos: [],
    })

    expect(body).toContain('Festival do Rio SSR')
  })

  it('renders a film title and synopsis', async () => {
    const body = await renderPage(
      'Peliculas/Show',
      {
        backPath: '/pt/peliculas',
        crumbs: [],
        pelicula: {
          ano_coord_int: 2025,
          banner_image: null,
          carousel_images: [],
          cor_coord_int: 'Color',
          diretor_coord_int: 'Christopher Nolan',
          display_paises: 'Brasil',
          display_sinopse: 'Um jovem bilionário se torna o Batman.',
          display_titulo: 'Batman',
          duracao_coord_int: 140,
          genre: 'Documentário',
          imageURL: 'https://images.example.test/batman.jpg',
          mostra_name: 'Première Brasil',
          mostra_tag_class: 'bg-primary',
          programacoesAsJson: [],
          teams: {},
          titulo_ingles_coord_int: 'Batman Begins',
          titulo_portugues_coord_int: 'Batman',
          vimeo_link_trailer: null,
          youtube_link_trailer: null,
        },
      },
      '/pt/peliculas/batman-link',
    )

    expect(body).toContain('Batman')
    expect(body).toContain('Um jovem bilionário se torna o Batman.')
  })

  it('renders a news title and body', async () => {
    const body = await renderPage(
      'Noticias/Show',
      {
        breadcrumbs: [
          { href: '/pt', label: 'Home' },
          { href: '/pt/noticias', label: 'Notícias' },
          { href: '', label: 'TEST TALENTS ONE titulo' },
        ],
        chamada: 'test TALENTS ONE chamada',
        conteudo: '<p>test TALENTS ONE conteudo</p>',
        titulo: 'TEST TALENTS ONE titulo',
      },
      '/pt/noticias/test-talents-one-titulo',
    )

    expect(body).toContain('TEST TALENTS ONE titulo')
    expect(body).toContain('test TALENTS ONE conteudo')
  })
})
