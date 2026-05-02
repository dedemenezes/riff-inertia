require "test_helper"

class BaseResourceTest < ActiveSupport::TestCase
  test "Noticia has permalink column" do
    assert Noticia.column_names.include?("permalink"),
      "Noticia must have permalink column for find_record_method to work"
  end

  test "Caderno does not have permalink column" do
    assert_not Caderno.column_names.include?("permalink"),
      "Caderno must fall back to find(id) in find_record_method"
  end

  test "Noticia is findable by permalink" do
    noticia = noticias(:one_talents)
    found = Noticia.find_by!(permalink: noticia.permalink)
    assert_equal noticia.id, found.id
  end

  test "Caderno is findable by id" do
    caderno = cadernos(:talents)
    found = Caderno.find(caderno.id)
    assert_equal caderno.id, found.id
  end
end
