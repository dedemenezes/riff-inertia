require "test_helper"

class ProgramFilterOptionsTest < ActionDispatch::IntegrationTest
  class DummyController < ActionController::Base
    include ProgramFilterOptions
  end

  setup do
    @controller = DummyController.new
  end

  test "to_filter_collection builds filter array with locale parameter" do
    mostras = Mostra.where(edicao_id: Edicao.current.id).limit(2).to_a

    result = @controller.send(:to_filter_collection, mostras, "mostra", locale: :pt)

    assert result.is_a?(Array)
    assert result.length == mostras.length

    result.each_with_index do |item, idx|
      assert_equal mostras[idx].filter_value, item["filter_value"]
      assert_equal mostras[idx].filter_display(locale: :pt), item["filter_display"]
      assert_equal I18n.t("filter.mostra", locale: :pt), item["filter_label"]
    end
  end

  test "to_filter_collection defaults to I18n.locale when not provided" do
    mostra = Mostra.where(edicao_id: Edicao.current.id).first
    mostras = [ mostra ]

    I18n.with_locale(:en) do
      result = @controller.send(:to_filter_collection, mostras, "mostra")

      assert result.is_a?(Array)
      assert_equal mostra.filter_display(locale: :en), result.first["filter_display"]
      assert_equal I18n.t("filter.mostra", locale: :en), result.first["filter_label"]
    end
  end

  test "strings_to_filter_collection builds filter array from strings" do
    directors = [ "Christopher Nolan", "Wachowskis", "João Silva" ]

    result = @controller.send(:strings_to_filter_collection, directors, "direcao", locale: :pt)

    assert result.is_a?(Array)
    assert_equal 3, result.length

    result.each_with_index do |item, idx|
      assert_equal directors[idx], item["filter_value"]
      assert_equal directors[idx], item["filter_display"]
      assert_equal I18n.t("filter.direcao", locale: :pt), item["filter_label"]
    end
  end

  test "strings_to_filter_collection defaults to I18n.locale when not provided" do
    directors = [ "Christopher Nolan" ]

    I18n.with_locale(:en) do
      result = @controller.send(:strings_to_filter_collection, directors, "direcao")

      assert_equal 1, result.length
      assert_equal "Christopher Nolan", result.first["filter_value"]
      assert_equal I18n.t("filter.direcao", locale: :en), result.first["filter_label"]
    end
  end

  test "pelicula_collection_service genres returns strings" do
    service = PeliculaCollectionService.new
    genres = service.collection_for_genres

    assert genres.is_a?(Array)
    unless genres.empty?
      genres.each do |genre|
        assert genre.is_a?(String), "Expected string but got #{genre.inspect}"
      end
    end
  end

  test "pelicula_collection_service directors returns strings" do
    service = PeliculaCollectionService.new
    directors = service.collection_for_directors

    assert directors.is_a?(Array)
    unless directors.empty?
      directors.each do |director|
        assert director.is_a?(String), "Expected string but got #{director.inspect}"
      end
    end
  end

  test "pelicula_collection_service actors returns strings" do
    service = PeliculaCollectionService.new
    actors = service.collection_for_actors

    assert actors.is_a?(Array)
    unless actors.empty?
      actors.each do |actor|
        assert actor.is_a?(String), "Expected string but got #{actor.inspect}"
      end
    end
  end
end
