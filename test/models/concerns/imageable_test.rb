require "test_helper"

class ImageableTest < ActiveSupport::TestCase
  class DummyModel
    include Imageable

    attr_accessor :imagem

    def initialize(imagem: nil)
      @imagem = imagem
    end

    def image_path_prefix = "imagens/dummy"
    def image_default_size = "medium"
  end

  def setup
    @model = DummyModel.new(imagem: "foto.jpg")
  end

  test "image_url returns correct URL with default size" do
    ENV.stub(:fetch, "https://example.com") do
      assert_equal "https://example.com/imagens/dummy/medium/foto.jpg", @model.image_url
    end
  end

  test "image_url accepts custom size" do
    ENV.stub(:fetch, "https://example.com") do
      assert_equal "https://example.com/imagens/dummy/large/foto.jpg", @model.image_url("large")
    end
  end

  test "image_url returns nil when imagem is blank" do
    @model.imagem = nil
    assert_nil @model.image_url
  end

  test "image_url returns nil when imagem is empty string" do
    @model.imagem = ""
    assert_nil @model.image_url
  end
end
