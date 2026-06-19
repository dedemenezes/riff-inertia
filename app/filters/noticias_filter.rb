# frozen_string_literal: true

# Builds caderno filter options and applies date / caderno params to a Noticia relation.
class NoticiasFilter
  Result = Struct.new(
    :relation,
    :selected_query,
    :selected_date,
    :selected_caderno,
    :cadernos,
    keyword_init: true
  )

  def initialize(relation:, params:, locale: I18n.locale, cadernos_relation: Caderno.all, date_mode: :from_date)
    @relation = relation
    @params = params
    @locale = (locale || I18n.locale).to_sym
    @cadernos_relation = cadernos_relation
    @date_mode = date_mode
  end

  def call
    cadernos = build_cadernos_options
    selected_query = nil
    selected_date = nil
    selected_caderno = nil
    relation = @relation

    query = @params[:query].to_s.strip
    if query.present?
      term = "%#{ActiveRecord::Base.sanitize_sql_like(query.downcase)}%"
      relation = relation.where(
        "LOWER(noticias.titulo) LIKE :term OR LOWER(noticias.chamada) LIKE :term",
        term: term
      )
      selected_query = {
        "filter_display" => query,
        "filter_value" => query,
        "filter_label" => I18n.t("filter.busca")
      }
    end

    if @params[:data].present?
      parsed_date = parse_date(@params[:data])

      if parsed_date
        selected_date = {
          "filter_display" => @params[:data],
          "filter_value" => @params[:data],
          "filter_label" => I18n.t("filter.date")
        }
        relation = relation.where(data: date_filter_for(parsed_date))
      end
    end

    if @params[:caderno].present?
      selected_caderno = cadernos.find { |c| c["filter_value"] == @params[:caderno] }
      if selected_caderno
        relation = if @locale == :pt
          relation.where(caderno: { permalink_pt: @params[:caderno] })
        else
          relation.where(caderno: { permalink_en: @params[:caderno] })
        end
      else
        relation = relation.none
      end
    end

    Result.new(
      relation: relation,
      selected_query: selected_query,
      selected_date: selected_date,
      selected_caderno: selected_caderno,
      cadernos: cadernos
    )
  end

  private

  def build_cadernos_options
    permalink_column = @locale == :pt ? :permalink_pt : :permalink_en
    display_column = @locale == :pt ? :nome_pt : :nome_en

    @cadernos_relation
      .where.not(permalink_column => [ nil, "" ])
      .pluck(permalink_column, display_column)
      .reject { |permalink, display| permalink.blank? || display.blank? }
      .uniq
      .sort
      .map { |item| Caderno.build_filter_json(item, :caderno) }
  end

  def parse_date(value)
    Date.iso8601(value.to_s)
  rescue ArgumentError
    nil
  end

  def date_filter_for(date)
    return date if @date_mode == :exact

    date..Date.today
  end
end
