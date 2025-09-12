module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def collection_for(field_name, filter_params_key)
      full_field_collection = filter_scope(field_name)
      return unless block_given?

      block_return = yield(full_field_collection)
      block_return.compact_blank
                  .uniq
                  .sort
                  .map { |item| build_filter_json(item, filter_params_key) }
    end

    def build_filter_json(value, key)
      {
        "filter_display" => value,
        "filter_value" => value,
        "filter_label" => I18n.t("filter.#{key}")
      }
    end

    def filter_scope(field_name)
      where(edicao_id: ApplicationRecord::EDICAO_ATUAL)
        .where.not(field_name => [ nil, "" ])
        .pluck(field_name)
    end
  end
end
