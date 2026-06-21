require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home renders without error" do
    with_youtube_stub do
      get root_url(locale: :pt)
    end

    assert_response :success

    props = inertia_props
    assert_equal "pt", props["currentLocale"]
    assert props["webdoors"].is_a?(Array), "Expected webdoors to be an array"
    assert props["noticias"].is_a?(Array), "Expected noticias to be an array"
  end

  test "home strips legacy HTML tags from news card titles" do
    noticias(:one_talents).update!(
      titulo: "<i>Birdman</i>, novo Iñárritu, vai abrir o Festival de Veneza",
      created: Time.current
    )

    with_youtube_stub do
      get root_url(locale: :pt)
    end

    titles = inertia_props["noticias"].map { |noticia| noticia["titulo"] }
    assert_includes titles, "Birdman, novo Iñárritu, vai abrir o Festival de Veneza"
    titles.each { |title| assert_no_match(/<[^>]+>/, title) }
  end

  private

  def with_youtube_stub
    previous_base_url = ENV["YT_BASE_URL"]
    previous_channel_id = ENV["YT_CHANNEL_ID"]
    previous_api_key = ENV["YT_API_KEY"]

    ENV["YT_BASE_URL"] = "https://example.com/youtube"
    ENV["YT_CHANNEL_ID"] = "playlist"
    ENV["YT_API_KEY"] = "api-key"

    HTTParty.stub(:get, { "items" => [] }) do
      yield
    end
  ensure
    restore_env("YT_BASE_URL", previous_base_url)
    restore_env("YT_CHANNEL_ID", previous_channel_id)
    restore_env("YT_API_KEY", previous_api_key)
  end

  def restore_env(key, value)
    if value.nil?
      ENV.delete(key)
    else
      ENV[key] = value
    end
  end
end
