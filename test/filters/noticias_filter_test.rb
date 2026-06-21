require "test_helper"

class NoticiasFilterTest < ActiveSupport::TestCase
  test "falls back to current locale when locale is nil" do
    I18n.with_locale(:pt) do
      filter = NoticiasFilter.new(
        relation: Noticia.includes(:caderno).published,
        params: { caderno: cadernos(:felix).permalink_pt },
        locale: nil
      ).call

      assert_equal cadernos(:felix).permalink_pt, filter.selected_caderno["filter_value"]
      assert filter.relation.all? { |noticia| noticia.caderno == cadernos(:felix) }
    end
  end

  test "ignores blank query after trimming whitespace" do
    filter = NoticiasFilter.new(
      relation: Noticia.includes(:caderno).published,
      params: { query: "   " }
    ).call

    assert_nil filter.selected_query
    assert_equal Noticia.published.count, filter.relation.count
  end

  test "filters news from start date" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-11" }
    ).call

    assert_equal [ "2025-08-11", "2025-08-12" ], [
      filter.selected_date["filter_params"]["data_inicio"],
      filter.relation.maximum(:data).iso8601
    ]
    assert_not_includes filter.relation, noticias(:one_talents)
    assert_includes filter.relation, noticias(:one_felix)
  end

  test "filters news inside date range" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-10", data_fim: "2025-08-10" }
    ).call

    assert_equal "2025-08-10..2025-08-10", filter.selected_date["filter_value"]
    assert_equal({ "data_inicio" => "2025-08-10", "data_fim" => "2025-08-10" }, filter.selected_date["filter_params"])
    assert_equal [ noticias(:one_talents) ], filter.relation.to_a
  end

  test "ignores end date without start date" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_fim: "2025-08-12" }
    ).call

    assert_nil filter.selected_date
    assert_equal Noticia.published.count, filter.relation.count
  end

  test "ignores invalid and inverted date ranges" do
    invalid = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "not-a-date" }
    ).call
    inverted = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-12", data_fim: "2025-08-10" }
    ).call

    assert_nil invalid.selected_date
    assert_nil inverted.selected_date
    assert_equal Noticia.published.count, invalid.relation.count
    assert_equal Noticia.published.count, inverted.relation.count
  end

  test "rejects date filters outside configured bounds" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-12" },
      date_bounds: { min: "2025-08-01", max: "2025-08-11" }
    ).call

    assert_nil filter.selected_date
    assert_equal Noticia.published.count, filter.relation.count
  end

  test "caps open ended start date filters at configured max bound" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-10" },
      date_bounds: { max: "2025-08-11" }
    ).call

    assert_equal "2025-08-10", filter.selected_date["filter_value"]
    assert_includes filter.relation, noticias(:one_talents)
    assert_not_includes filter.relation, noticias(:one_felix)
  end

  test "normalizes date bounds from time-like objects" do
    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: { data_inicio: "2025-08-10" },
      date_bounds: {
        min: Time.zone.local(2025, 8, 10, 9, 0, 0),
        max: Time.zone.local(2025, 8, 11, 18, 0, 0)
      }
    ).call

    assert_equal "2025-08-10", filter.selected_date["filter_value"]
    assert_includes filter.relation, noticias(:one_talents)
    assert_not_includes filter.relation, noticias(:one_felix)
  end

  test "rejects caderno options with blank permalink or display" do
    valid_caderno = Caderno.create!(
      nome_en: "Review Option",
      nome_pt: "Opção Válida",
      permalink_en: "review-option",
      permalink_pt: "opcao-valida",
      created: Time.current
    )
    Caderno.create!(
      nome_en: "Blank Display",
      nome_pt: "",
      permalink_en: "blank-display",
      permalink_pt: "blank-display",
      created: Time.current
    )
    Caderno.create!(
      nome_en: "Blank Permalink",
      nome_pt: "Permalink em branco",
      permalink_en: "",
      permalink_pt: "",
      created: Time.current
    )

    filter = NoticiasFilter.new(
      relation: Noticia.published,
      params: {},
      locale: :pt,
      cadernos_relation: Caderno.where(id: [
        valid_caderno.id,
        Caderno.find_by(nome_en: "Blank Display").id,
        Caderno.find_by(nome_en: "Blank Permalink").id
      ])
    ).call

    assert_equal [ "opcao-valida" ], filter.cadernos.map { |caderno| caderno["filter_value"] }
  end
end
