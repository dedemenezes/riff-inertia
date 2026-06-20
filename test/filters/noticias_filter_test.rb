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
