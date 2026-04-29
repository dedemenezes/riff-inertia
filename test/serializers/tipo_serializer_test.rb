require "test_helper"

class TipoSerializerTest < ActiveSupport::TestCase
  setup do
    @tipo = tipos(:meu_redentor)
  end

  test "returns tipo_id" do
    result = TipoSerializer.new(@tipo).as_json
    assert_equal @tipo.id, result[:tipo_id]
  end

  test "returns nome_pt when locale is pt" do
    I18n.with_locale(:pt) do
      result = TipoSerializer.new(@tipo).as_json
      assert_equal @tipo.nome_pt, result[:tipo_nome]
    end
  end

  test "returns nome_en when locale is en" do
    I18n.with_locale(:en) do
      result = TipoSerializer.new(@tipo).as_json
      assert_equal @tipo.nome_en, result[:tipo_nome]
    end
  end

  test "accepts explicit locale override" do
    result = TipoSerializer.new(@tipo, locale: :en).as_json
    assert_equal @tipo.nome_en, result[:tipo_nome]
  end
end
