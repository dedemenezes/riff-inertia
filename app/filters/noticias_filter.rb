# frozen_string_literal: true

# Builds caderno filter options and applies date range / caderno params to a Noticia relation.
class NoticiasFilter
  Result = Struct.new(
    :relation,
    :selected_query,
    :selected_date,
    :selected_caderno,
    :cadernos,
    keyword_init: true
  )

  def initialize(relation:, params:, locale: I18n.locale, cadernos_relation: Caderno.all, date_bounds: {})
    @relation = relation
    @params = params
    @locale = (locale || I18n.locale).to_sym
    @cadernos_relation = cadernos_relation
    @date_bounds = normalize_date_bounds(date_bounds)
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

    date_range = build_date_range
    if date_range
      relation = relation.where(data: date_range[:range])
      selected_date = build_selected_date(date_range)
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

  def normalize_date_bounds(date_bounds)
    {
      min: parse_bound_date(date_bounds[:min] || date_bounds["min"]),
      max: parse_bound_date(date_bounds[:max] || date_bounds["max"])
    }
  end

  def parse_bound_date(value)
    return nil if value.blank?
    return value.to_date if value.respond_to?(:to_date)

    parse_date(value)
  end

  def build_date_range
    start_date = parse_date(@params[:data_inicio])
    return nil unless start_date

    end_date = parse_date(@params[:data_fim])
    return nil if end_date && end_date < start_date
    return nil unless within_date_bounds?(start_date) && (!end_date || within_date_bounds?(end_date))

    end_value = end_date || @date_bounds[:max]

    {
      start_date: start_date,
      end_date: end_date,
      range: end_value ? start_date..end_value : start_date..
    }
  end

  def within_date_bounds?(date)
    return false if @date_bounds[:min] && date < @date_bounds[:min]
    return false if @date_bounds[:max] && date > @date_bounds[:max]

    true
  end

  def build_selected_date(date_range)
    start_value = date_range[:start_date].iso8601
    end_value = date_range[:end_date]&.iso8601
    filter_params = { "data_inicio" => start_value }
    filter_params["data_fim"] = end_value if end_value

    {
      "filter_display" => end_value ? "#{start_value} - #{end_value}" : start_value,
      "filter_value" => end_value ? "#{start_value}..#{end_value}" : start_value,
      "filter_label" => I18n.t("filter.date"),
      "filter_params" => filter_params
    }
  end
end
