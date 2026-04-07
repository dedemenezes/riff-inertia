# frozen_string_literal: true

# Builds caderno filter options and applies date / caderno params to a Noticia relation.
class NoticiasFilter
  Result = Struct.new(
    :relation,
    :selected_date,
    :selected_caderno,
    :cadernos,
    keyword_init: true
  )

  def initialize(relation:, params:, locale: I18n.locale)
    @relation = relation
    @params = params
    @locale = locale.to_sym
  end

  def call
    cadernos = build_cadernos_options
    selected_date = nil
    selected_caderno = nil
    relation = @relation

    if @params[:data].present?
      selected_date = {
        filter_display: @params[:data],
        filter_value: @params[:data],
        filter_label: I18n.t("filter.date")
      }
      date_range = (Date.parse(selected_date[:filter_value])..Date.today)
      relation = relation.where(data: date_range)
    end

    if @params[:caderno].present?
      selected_caderno = cadernos.find { |c| c["filter_value"] == @params[:caderno] }
      relation = if @locale == :pt
        relation.where(caderno: { permalink_pt: @params[:caderno] })
      else
        relation.where(caderno: { permalink_en: @params[:caderno] })
      end
    end

    Result.new(
      relation: relation,
      selected_date: selected_date,
      selected_caderno: selected_caderno,
      cadernos: cadernos
    )
  end

  private

  def build_cadernos_options
    if @locale == :pt
      Caderno.collection_without_edition_for(:permalink_pt, :nome_pt, :caderno)
    else
      Caderno.collection_without_edition_for(:permalink_en, :nome_en, :caderno)
    end
  end
end
