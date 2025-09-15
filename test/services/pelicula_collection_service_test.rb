require "test_helper"

class PeliculaCollectionServiceTest < ActiveSupport::TestCase
  def setup
    @service = PeliculaCollectionService.new
    @edicao_id = 12
  end

  test "collection_for_genres returns genres in Portuguese" do
    I18n.with_locale(:pt) do
      genres = @service.collection_for_genres
      assert_equal "Animação", genres.first["filter_value"]
      assert_equal "Documentário", genres.second["filter_value"]
    end
  end

  test "collection_for_genres returns genres in English" do
    I18n.with_locale(:en) do
      genres = @service.collection_for_genres
      assert_equal "Animation", genres.first["filter_value"]
      assert_equal "Documentary", genres.second["filter_value"]
    end
  end

  test "with_actor finds peliculas by actor name" do
    results = @service.with_actor("Christian Bale", @edicao_id)
    assert_equal [ peliculas(:batman) ].sort, results.to_a.sort
  end

  test "with_actor finds peliculas by case-insensitive search" do
    results = @service.with_actor("babu sAntana", @edicao_id)
    assert_equal [ peliculas(:special_char) ].sort, results.to_a.sort
  end

  test "with_actor returns empty relation for unknown actor" do
    results = @service.with_actor("Unknown Actor", @edicao_id)
    assert_empty results
  end
end
