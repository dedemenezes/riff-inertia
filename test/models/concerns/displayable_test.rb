require "test_helper"

class DisplayableTest < ActiveSupport::TestCase
  class DummyClass
    include Displayable

    attr_accessor :titulo_portugues_coord_int, :titulo_ingles_coord_int,
                  :sinopse_port_export, :sinopse_ing_export,
                  :catalogo_ficha_2007, :paises

    def initialize
      self.paises = []
    end
  end

  def setup
    @object = DummyClass.new
    @object.titulo_portugues_coord_int = "Título em Português"
    @object.titulo_ingles_coord_int = "English Title"
    @object.sinopse_port_export = "Sinopse em português"
    @object.sinopse_ing_export = "Synopsis in English"
    @object.catalogo_ficha_2007 = "Drama/Drama Romance Action"
  end

  test "display_titulo returns Portuguese title when locale is pt" do
    I18n.with_locale(:pt) do
      assert_equal "Título em Português", @object.display_titulo
    end
  end

  test "display_titulo returns English title when locale is en" do
    I18n.with_locale(:en) do
      assert_equal "English Title", @object.display_titulo
    end
  end

  test "display_sinopse returns Portuguese synopsis when locale is pt" do
    I18n.with_locale(:pt) do
      assert_equal "Sinopse em português", @object.display_sinopse
    end
  end

  test "display_sinopse returns English synopsis when locale is en" do
    I18n.with_locale(:en) do
      assert_equal "Synopsis in English", @object.display_sinopse
    end
  end

  test "genre returns Portuguese genre when locale is pt" do
    I18n.with_locale(:pt) do
      assert_equal "Drama", @object.genre
    end
  end

  test "genre returns English genre when locale is en" do
    I18n.with_locale(:en) do
      assert_equal "Drama", @object.genre
    end
  end

  test "genre returns TBD when catalogo_ficha_2007 is nil" do
    @object.catalogo_ficha_2007 = nil
    assert_equal "TBD", @object.genre
  end

  test "display_paises returns single country name" do
    pais1 = Minitest::Mock.new
    pais1.expect(:nome_pais, "Brasil")

    @object.paises = [ pais1 ]
    assert_equal "Brasil", @object.display_paises

    pais1.verify
  end

  test "display_paises returns formatted string for multiple countries" do
    pais1 = Minitest::Mock.new
    pais2 = Minitest::Mock.new
    pais3 = Minitest::Mock.new

    pais1.expect(:nome_pais, "Brasil")
    pais2.expect(:nome_pais, "França")
    pais3.expect(:nome_pais, "Alemanha")

    @object.paises = [ pais1, pais2, pais3 ]
    assert_equal "Brasil + 2 países", @object.display_paises

    pais1.verify
    pais2.verify
    pais3.verify
  end
end
