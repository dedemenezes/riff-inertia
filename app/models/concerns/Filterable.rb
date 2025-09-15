module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def collection_for(field_name, field_display = nil, filter_params_key)
      field_display ||= field_name

      full_field_collection = filter_scope(field_name)
      return unless block_given?

      block_return = yield(full_field_collection)
      block_return.compact_blank
                  .uniq
                  .sort
                  .map { |item| build_filter_json(item, filter_params_key) }
    end

    def build_filter_json(value, key)
      logger.debug(value)
      if value.is_a?(Array)
        display = value.second
        value = value.first
      else
        # binding.b
        display = value
      end
      {
        "filter_display" => display,
        "filter_value" => value,
        "filter_label" => I18n.t("filter.#{key}")
      }
    end

    def filter_scope(field_name)
      where(edicao_id: ApplicationRecord::EDICAO_ATUAL)
        .where.not(field_name => [ nil, "" ])
        .pluck(field_name)
    end

    # HORRIVEL MAS EH ISSO
    def collection_without_edition_for(field_name, field_display = nil, filter_params_key)
      field_display ||= field_name
      full_field_collection = no_edition_filter_scope(field_name, field_display)
      # return unless block_given?

      full_field_collection = yield(full_field_collection) if block_given?
      full_field_collection.compact_blank
                  .uniq
                  .sort
                  .map { |item| build_filter_json(item, filter_params_key) }
    end

    def no_edition_filter_scope(field_name, field_display)
      where.not(field_name => [ nil, "" ])
        .pluck(field_name, field_display)
    end
  end
end
