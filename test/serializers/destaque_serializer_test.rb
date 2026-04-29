require "test_helper"

class DestaqueSerializerTest < ActiveSupport::TestCase
  setup do
    @destaque = destaques(:karim_ainouz)
  end

  test "returns expected keys" do
    result = DestaqueSerializer.new(@destaque).as_json
    assert_equal %i[id titulo url destino imagem], result.keys
  end

  test "returns correct field values" do
    result = DestaqueSerializer.new(@destaque).as_json
    assert_equal @destaque.id,       result[:id]
    assert_equal @destaque.titulo,   result[:titulo]
    assert_equal @destaque.url,      result[:url]
    assert_equal @destaque.destino,  result[:destino]
    assert_equal @destaque.image_url, result[:imagem]
  end

  test "imagem uses image_url helper" do
    result = DestaqueSerializer.new(@destaque).as_json
    assert_includes result[:imagem], @destaque.imagem
  end
end
