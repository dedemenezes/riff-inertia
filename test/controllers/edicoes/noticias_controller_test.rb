require "test_helper"

class Edicoes::NoticiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edicao = edicoes(:edicao_12)
    @idioma = idiomas(:port)
    @talents = cadernos(:talents)
    @felix = cadernos(:felix)

    create_news!(
      title: "Alpha notícia da edição",
      permalink: "alpha-noticia-da-edicao",
      caderno: @talents,
      data: "2024-10-03",
      created: 3.days.ago
    )
    create_news!(
      title: "Zulu notícia da edição",
      permalink: "zulu-noticia-da-edicao",
      caderno: @felix,
      data: "2024-10-04",
      chamada: "Texto com palavra rara",
      created: 2.days.ago
    )
    create_news!(
      title: "Beta notícia da edição",
      permalink: "beta-noticia-da-edicao",
      caderno: @talents,
      data: "2024-10-05",
      created: 1.day.ago
    )
    create_news!(
      title: "Notícia fora da edição",
      permalink: "noticia-fora-da-edicao",
      caderno: @talents,
      data: "2023-10-08",
      created: Time.current
    )
  end

  test "index renders previous edition news scoped by edition date range" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt)

    assert_response :success
    assert_equal "Edicoes/Noticias", inertia_component

    props = inertia_props
    titles = props["elements"].map { |news| news["titulo"] }

    assert_equal @edicao.id, props["edicao"]["id"]
    assert_includes titles, "Alpha notícia da edição"
    assert_includes titles, "Beta notícia da edição"
    assert_includes titles, "Zulu notícia da edição"
    assert_not_includes titles, "Notícia fora da edição"
    assert_equal edicao_anterior_noticias_path(@edicao, locale: :pt), props["tabBaseUrl"]
  end

  test "query filters news by title and chamada" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt, query: "rara")

    assert_response :success

    props = inertia_props
    assert_equal [ "Zulu notícia da edição" ], props["elements"].map { |news| news["titulo"] }
    assert_equal "rara", props["current_filters"]["query"]["filter_value"]
    assert props["has_active_filters"]
  end

  test "index strips legacy HTML tags from previous edition news card titles" do
    create_news!(
      title: "<i>Birdman</i>, novo Iñárritu, vai abrir o Festival de Veneza",
      permalink: "i-birdman-i-novo-inarritu-vai-abrir-o-festival-de-veneza",
      caderno: @talents,
      data: "2024-10-06",
      created: Time.current
    )

    get edicao_anterior_noticias_path(@edicao, locale: :pt, query: "birdman")

    assert_response :success

    titles = inertia_props["elements"].map { |news| news["titulo"] }
    assert_equal [ "Birdman, novo Iñárritu, vai abrir o Festival de Veneza" ], titles
    titles.each { |title| assert_no_match(/<[^>]+>/, title) }
  end

  test "caderno filter narrows previous edition news" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt, caderno: @felix.permalink_pt)

    assert_response :success

    props = inertia_props
    assert_equal [ "Zulu notícia da edição" ], props["elements"].map { |news| news["titulo"] }
    assert_equal @felix.permalink_pt, props["current_filters"]["caderno"]["filter_value"]
    assert_equal [ @talents.permalink_pt, @felix.permalink_pt ].sort, props["cadernos"].map { |c| c["filter_value"] }.sort
  end

  test "date filter matches exact publication date inside the edition range" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt, data: "2024-10-04")

    assert_response :success

    props = inertia_props
    assert_equal [ "Zulu notícia da edição" ], props["elements"].map { |news| news["titulo"] }
    assert_equal "2024-10-04", props["current_filters"]["data"]["filter_value"]
  end

  test "invalid date and page params fall back safely" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt, data: "not-a-date", page: "0")

    assert_response :success

    props = inertia_props
    assert_equal 1, props["pagy"]["page"]
    assert_nil props["current_filters"]["data"]
    assert_includes props["elements"].map { |news| news["titulo"] }, "Alpha notícia da edição"
  end

  test "sort toggles ascending and descending by title" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt, sort: "asc")
    asc = inertia_props["elements"].map { |news| news["titulo"] }

    get edicao_anterior_noticias_path(@edicao, locale: :pt, sort: "desc")
    desc = inertia_props["elements"].map { |news| news["titulo"] }

    assert_equal "Alpha notícia da edição", asc.first
    assert_equal "Zulu notícia da edição", desc.first
  end

  test "index serializes only fields used by the news listing card" do
    get edicao_anterior_noticias_path(@edicao, locale: :pt)

    news = inertia_props["elements"].first

    assert_includes news.keys, "id"
    assert_includes news.keys, "titulo"
    assert_includes news.keys, "permalink"
    assert_includes news.keys, "chamada"
    assert_includes news.keys, "image_url"
    assert_includes news.keys, "caderno_nome"
    assert_includes news.keys, "display_date"

    assert_not_includes news.keys, "conteudo"
    assert_not_includes news.keys, "hora"
  end

  private

  def create_news!(title:, permalink:, caderno:, data:, created:, chamada: "Chamada da notícia")
    Noticia.create!(
      idioma: @idioma,
      caderno: caderno,
      data: data,
      hora: "10:00",
      titulo: title,
      permalink: permalink,
      imagem: "3281cf9b6dd1fc05aa42e9d0c47ba471.jpg",
      chamada: chamada,
      conteudo: "<p>Conteúdo da notícia</p>",
      ativo: 1,
      created: created,
      updated: created
    )
  end

  def inertia_component
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value
    JSON.parse(data_page)["component"]
  end
end
