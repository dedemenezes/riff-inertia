require "test_helper"

class TeamParseableTest < ActiveSupport::TestCase
  class TestModel
    include TeamParseable

    attr_accessor :diretor_coord_int, :fotografia_coord_int

    def diretor_team
      parse_team(diretor_coord_int)
    end

    def fotografia_team
      parse_team(fotografia_coord_int)
    end
  end

  setup do
    @model = TestModel.new
  end

  test "parses comma separated team members" do
    @model.diretor_coord_int = "Christopher Nolan, Denis Villeneuve"
    assert_equal [ "Christopher Nolan", "Denis Villeneuve" ], @model.diretor_team
  end

  test "strips whitespace from team members" do
    @model.fotografia_coord_int = " Roger Deakins , Emmanuel Lubezki "
    assert_equal [ "Roger Deakins", "Emmanuel Lubezki" ], @model.fotografia_team
  end

  test "returns empty array for nil field" do
    @model.diretor_coord_int = nil
    assert_equal nil, @model.diretor_team
  end

  test "returns empty array for empty string" do
    @model.diretor_coord_int = ""
    assert_equal nil, @model.diretor_team
  end

  test "handles single team member" do
    @model.diretor_coord_int = "Christopher Nolan"
    assert_equal [ "Christopher Nolan" ], @model.diretor_team
  end
end
