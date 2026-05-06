require "test_helper"

class TalentsControllerTest < ActionDispatch::IntegrationTest
  test "news returns inertia response with default locale" do
    get talents_news_url

    assert_response :success
    props = inertia_props

    assert_equal "pt", props["currentLocale"]
    assert props["noticias"].is_a?(Array)
    assert props["tabs"].is_a?(Array)
  end

  test "news active tab is noticias_e_criticas" do
    get talents_news_url(locale: :pt)

    assert_response :success
    props = inertia_props
    tabs = props["tabs"]

    active_labels = tabs.select { |t| t["active"] }.map { |t| t["label"] }
    assert_equal [ "Notícias e Críticas" ], active_labels
  end

  test "news only includes noticias from talents-rio caderno" do
    get talents_news_url(locale: :pt)

    assert_response :success
    props = inertia_props

    assert props["noticias"].any?, "Expected at least one talents noticia"
    assert props["noticias"].all? { |n| n["caderno_nome"] == "Talents Rio" }
  end

  test "news excludes noticias from other cadernos" do
    get talents_news_url(locale: :pt)

    props = inertia_props
    titles = props["noticias"].map { |n| n["titulo"] }

    assert_not_includes titles, "TEST FELIX TWO titulo"
  end

  test "news in en locale returns english talents noticias" do
    get talents_news_url(locale: :en)

    assert_response :success
    props = inertia_props

    assert_equal "en", props["currentLocale"]
    assert props["noticias"].is_a?(Array)
  end

  test "programacao returns inertia response with sections and tabs" do
    get talents_programacao_url(locale: :pt)

    assert_response :success
    props = inertia_props

    assert props["sections"].is_a?(Array)
    assert props["tabs"].is_a?(Array)
  end

  test "programacao active tab is programacao" do
    get talents_programacao_url(locale: :pt)

    props = inertia_props
    active_labels = props["tabs"].select { |t| t["active"] }.map { |t| t["label"] }

    assert_equal [ "Programação" ], active_labels
  end
end
