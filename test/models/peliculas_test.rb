require "test_helper"

class PeliculaTest < ActiveSupport::TestCase
  test "display_titulo returns Portuguese title when locale is pt" do
    pelicula = peliculas(:amor_brasilia)
    I18n.with_locale(:pt) do
      assert_equal "Amor em Brasília", pelicula.display_titulo
    end
  end

  test "display_titulo returns English title when locale is en" do
    pelicula = peliculas(:amor_brasilia)
    I18n.with_locale(:en) do
      assert_equal "Love in Brasilia", pelicula.display_titulo
    end
  end
  test "actor_to_pelicula_mapping returns hash with actor names as keys" do
    pelicula = peliculas(:batman)

    mapping = Pelicula.actor_to_pelicula_mapping(pelicula.edicao_id)

    assert_instance_of Hash, mapping

    assert_includes mapping.keys, "Christian Bale"
    assert_includes mapping.keys, "Michael Caine"

    assert_instance_of Array, mapping["Christian Bale"]
    assert_instance_of Array, mapping["Michael Caine"]
  end

  test "actor_to_pelicula_mapping handles comma-separated actors correctly" do
    pelicula = peliculas(:matrix)

    mapping = Pelicula.actor_to_pelicula_mapping(pelicula.edicao_id)

    assert_includes mapping.keys, "Keanu Reeves"
    assert_includes mapping.keys, "Laurence Fishburne"

    assert_includes mapping["Keanu Reeves"], pelicula.id
    assert_includes mapping["Laurence Fishburne"], pelicula.id
  end

  test "actor_to_pelicula_mapping stores both exact and lowercase versions" do
    pelicula = peliculas(:batman)

    mapping = Pelicula.actor_to_pelicula_mapping(pelicula.edicao_id)

    assert_includes mapping.keys, "Christian Bale"
    assert_includes mapping.keys, "christian bale"

    assert_includes mapping["Christian Bale"], pelicula.id
    assert_includes mapping["christian bale"], pelicula.id

    assert_equal mapping["Christian Bale"], mapping["christian bale"]
  end

  test "actor_to_pelicula_mapping removes duplicate pelicula IDs" do
    pelicula1 = peliculas(:matrix)
    pelicula2 = peliculas(:test_0)

    # Ensure both have the same actor and same edicao_id
    assert_equal pelicula1.edicao_id, pelicula2.edicao_id

    mapping = Pelicula.actor_to_pelicula_mapping(pelicula1.edicao_id)

    # Should have both pelicula IDs for Christian Bale
    keanu_reeves_movies = mapping["Keanu Reeves"]
    assert_includes keanu_reeves_movies, pelicula1.id
    assert_includes keanu_reeves_movies, pelicula2.id

    # Should not have duplicates (uniq was called)
    assert_equal keanu_reeves_movies.length, keanu_reeves_movies.uniq.length
  end

  test "actor_to_pelicula_mapping ignores blank/nil elenco_coord_int" do
    pelicula_with_nil = peliculas(:cidade_transformacao)
    pelicula_with_cast = peliculas(:batman)

    edicao_id = pelicula_with_cast.edicao_id

    mapping = Pelicula.actor_to_pelicula_mapping(edicao_id)

    all_pelicula_ids = mapping.values.flatten.uniq

    refute_includes all_pelicula_ids, pelicula_with_nil.id
    assert_includes all_pelicula_ids, pelicula_with_cast.id
  end

  test "actor_to_pelicula_mapping handles actors with extra spaces" do
    pelicula = peliculas(:cidade_perdida)

    mapping = Pelicula.actor_to_pelicula_mapping(pelicula.edicao_id)

    assert_includes mapping.keys, "Pedro Costa"
    assert_includes mapping.keys, "Maria Santos"

    refute_includes mapping.keys, " Pedro Costa"
    refute_includes mapping.keys, "Maria Santos  "
    refute_includes mapping.keys, " Pedro Costa "

    assert_includes mapping["Pedro Costa"], pelicula.id
    assert_includes mapping["Maria Santos"], pelicula.id
  end

  test "with_actor finds peliculas by exact actor name" do
    pelicula = peliculas(:batman)
    edicao_id = pelicula.edicao_id

    results = Pelicula.with_actor("Christian Bale", edicao_id)

    assert_includes results.ids, pelicula.id

    results.each do |p|
      assert_equal edicao_id, p.edicao_id
    end
  end

  test "with_actor returns empty when actor not found" do
    edicao_id = peliculas(:batman).edicao_id

    results = Pelicula.with_actor("Non Existent Actor", edicao_id)

    assert_empty results
    assert_equal 0, results.count
  end

  test "with_actor works with actors containing special characters" do
    # Test with actors that have accents, hyphens, etc.
    pelicula = peliculas(:paris_stories) # Assuming elenco_coord_int: "François Truffaut, Jean-Luc Godard"
    edicao_id = pelicula.edicao_id

    # Search for actors with special characters
    results_accent = Pelicula.with_actor("François Truffaut", edicao_id)
    results_hyphen = Pelicula.with_actor("Jean-Luc Godard", edicao_id)

    # Should find the peliculas
    assert_includes results_accent.ids, pelicula.id
    assert_includes results_hyphen.ids, pelicula.id

    # Should handle the special characters correctly
    refute_empty results_accent
    refute_empty results_hyphen
  end

  test "caching works - second call doesn't hit database" do
    Rails.cache.clear
    original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    pelicula = peliculas(:batman)
    edicao_id = pelicula.edicao_id

    # Clear cache to ensure clean test
    Rails.cache.delete("actor-pelicula-mapping-#{edicao_id}")

    first_mapping = nil
    # First call should hit database
    assert_queries_count(1) do
      first_mapping = Pelicula.actor_to_pelicula_mapping(edicao_id)
    end

    second_mapping = nil
    # Second call should use cache (no database queries)
    assert_no_queries do
      second_mapping = Pelicula.actor_to_pelicula_mapping(edicao_id)
    end

    # Results should be identical
    first_mapping = Pelicula.actor_to_pelicula_mapping(edicao_id)
    second_mapping = Pelicula.actor_to_pelicula_mapping(edicao_id)

    assert_equal first_mapping, second_mapping

    # Verify cache key exists
    assert Rails.cache.exist?("actor-pelicula-mapping-#{edicao_id}")

    Rails.cache = original_cache
  end
  test "collection_for elenco returns all actors" do
    expected = Pelicula.pluck(:elenco_coord_int).map { _1.split(",") }.flatten.uniq.map(&:strip).count
    actual = Pelicula.collection_for_actors
    assert_equal expected, actual.count
  end
end
