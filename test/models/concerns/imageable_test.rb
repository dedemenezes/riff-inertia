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

  def setup
    @pelicula = DummyPelicula.new(imagem: "test_f01.jpg", imagem_producao: "poster.jpg")
  end

  test "imageURL returns correct URL with default parameters" do
    ENV.stub(:fetch, "https://example.com") do
      stub_const("ApplicationRecord::EDICAO_ATUAL_ANO", "2024") do
        expected_url = "https://example.com/2024/site/peliculas/original/test_f01.jpg"
        assert_equal expected_url, @pelicula.imageURL
      end
    end
  end

  test "imageURL returns correct URL with custom size" do
    ENV.stub(:fetch, "https://example.com") do
      stub_const("ApplicationRecord::EDICAO_ATUAL_ANO", "2024") do
        expected_url = "https://example.com/2024/site/peliculas/large/test_f01.jpg"
        assert_equal expected_url, @pelicula.imageURL(nil, "large")
      end
    end
  end

  test "imageURL returns nil for blank image" do
    @pelicula.imagem = nil
    assert_nil @pelicula.imageURL
  end

  test "posterImageURL returns correct poster URL" do
    ENV.stub(:fetch, "https://example.com") do
      stub_const("ApplicationRecord::EDICAO_ATUAL_ANO", "2024") do
        expected_url = "https://example.com/2024/site/peliculas/large/poster.jpg"
        assert_equal expected_url, @pelicula.posterImageURL
      end
    end
  end

  test "carousel_images generates carousel image URLs" do
    ENV.stub(:fetch, "https://example.com") do
      stub_const("ApplicationRecord::EDICAO_ATUAL_ANO", "2024") do
          # stub_const("DummyPelicula::CAROUSEL_IMAGES_AMOUNT", 3) do
          images = @pelicula.carousel_images
          assert_equal 3, images.length
          assert_includes images.first[:path], "test_f02.jpg"
          assert_includes images.last[:path], "test_f04.jpg"
        end
      # end
    end
  end

  test "carousel_images returns empty array for blank image" do
    @pelicula.imagem = ""
    assert_equal [], @pelicula.carousel_images
  end

  private

  # Mimic stub_const from RSpec in Minitest
  def stub_const(constant, value)
    parts = constant.to_s.split("::")
    parent = parts[0..-2].inject(Object) { |mod, name| mod.const_get(name) }
    name = parts.last

    original = parent.const_get(name)
    parent.send(:remove_const, name)
    parent.const_set(name, value)
    yield
  ensure
    parent.send(:remove_const, name)
    parent.const_set(name, original)
  end
end
