require "test_helper"

class ImageableTest < ActiveSupport::TestCase
  class DummyPelicula
    include Imageable

    attr_accessor :imagem, :imagem_producao

    def initialize(imagem: nil, imagem_producao: nil)
      @imagem = imagem
      @imagem_producao = imagem_producao
    end
  end

  TEST_EDICAO = Struct.new(:descricao, :id).new("2024", 12)

  def setup
    @pelicula = DummyPelicula.new(imagem: "test_f01.jpg", imagem_producao: "poster.jpg")
  end

  test "imageURL returns correct URL with default parameters" do
    ENV.stub(:fetch, "https://example.com") do
      Edicao.stub(:current, TEST_EDICAO) do
        expected_url = "https://example.com/2024/site/peliculas/original/test_f01.jpg"
        assert_equal expected_url, @pelicula.imageURL
      end
    end
  end

  test "imageURL returns correct URL with custom size" do
    ENV.stub(:fetch, "https://example.com") do
      Edicao.stub(:current, TEST_EDICAO) do
        expected_url = "https://example.com/2024/site/peliculas/large/test_f01.jpg"
        assert_equal expected_url, @pelicula.imageURL(nil, "large")
      end
    end
  end

  test "imageURL returns nil for blank image" do
    @pelicula.imagem = nil
    assert_nil @pelicula.imageURL
  end

  test "banner_image returns src, srcset, and sizes for responsive banner" do
    ENV.stub(:fetch, "https://example.com") do
      Edicao.stub(:current, TEST_EDICAO) do
        banner = @pelicula.banner_image
        assert_equal "https://example.com/2024/site/peliculas/large/test_f01.jpg", banner[:src]
        assert_includes banner[:srcset], "https://example.com/2024/site/peliculas/large/test_f01.jpg 300w"
        assert_includes banner[:srcset], "https://example.com/2024/site/peliculas/original/test_f01.jpg 1920w"
        assert_equal "100vw", banner[:sizes]
      end
    end
  end

  test "banner_image returns nil when imagem is blank" do
    @pelicula.imagem = nil
    assert_nil @pelicula.banner_image
  end

  test "posterImageURL returns correct poster URL" do
    ENV.stub(:fetch, "https://example.com") do
      Edicao.stub(:current, TEST_EDICAO) do
        expected_url = "https://example.com/2024/site/peliculas/large/poster.jpg"
        assert_equal expected_url, @pelicula.posterImageURL
      end
    end
  end

  test "carousel_images generates carousel image URLs" do
    ENV.stub(:fetch, "https://example.com") do
      Edicao.stub(:current, TEST_EDICAO) do
        images = @pelicula.carousel_images
        assert_equal 2, images.length
        assert_includes images.first[:path], "test_f02.jpg"
        assert_includes images.last[:path], "test_f03.jpg"
      end
    end
  end

  test "carousel_images returns empty array for blank image" do
    @pelicula.imagem = ""
    assert_equal [], @pelicula.carousel_images
  end
end
