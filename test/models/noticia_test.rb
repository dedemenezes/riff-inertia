require "test_helper"

class NoticiaTest < ActiveSupport::TestCase
  setup do
    @valid = noticias(:one_talents)
  end

  test "valid fixture passes validations" do
    assert @valid.valid?
  end

  test "requires data" do
    @valid.data = nil
    assert_not @valid.valid?
    assert @valid.errors[:data].any?
  end

  test "requires titulo" do
    @valid.titulo = nil
    assert_not @valid.valid?
    assert @valid.errors[:titulo].any?
  end

  test "titulo cannot exceed 150 characters" do
    @valid.titulo = "a" * 151
    assert_not @valid.valid?
    assert @valid.errors[:titulo].any?
  end

  test "display_title strips legacy HTML tags from title" do
    @valid.titulo = "<i>Birdman</i>, novo Iñárritu, vai abrir o Festival de Veneza"

    assert_equal "Birdman, novo Iñárritu, vai abrir o Festival de Veneza", @valid.display_title
  end

  test "display_title updates memoized value when title changes" do
    @valid.titulo = "Título sem HTML"
    assert_equal "Título sem HTML", @valid.display_title

    @valid.titulo = "<i>Birdman</i>, novo Iñárritu"

    assert_equal "Birdman, novo Iñárritu", @valid.display_title
  end

  test "requires permalink" do
    @valid.permalink = nil
    assert_not @valid.valid?
    assert @valid.errors[:permalink].any?
  end

  test "permalink cannot exceed 150 characters" do
    @valid.permalink = "a" * 151
    assert_not @valid.valid?
    assert @valid.errors[:permalink].any?
  end

  test "permalink must be unique" do
    duplicate = @valid.dup
    duplicate.titulo = "Another titulo"
    assert_not duplicate.valid?
    assert duplicate.errors[:permalink].any?
  end

  test "image_url returns full S3 URL for medium2 by default" do
    base_url = ENV.fetch("IMAGES_BASE_URL")
    expected = "#{base_url}/imagens/noticias/medium2/#{@valid.imagem}"
    assert_equal expected, @valid.image_url
  end

  test "image_url accepts custom size" do
    base_url = ENV.fetch("IMAGES_BASE_URL")
    expected = "#{base_url}/imagens/noticias/large/#{@valid.imagem}"
    assert_equal expected, @valid.image_url("large")
  end

  test "image_url returns nil when imagem is blank" do
    @valid.imagem = nil
    assert_nil @valid.image_url
  end
end
