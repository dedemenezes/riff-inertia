class Caderno < ApplicationRecord
  include Filterable
  has_many :noticias

  def self.for_filters
    select(:id, :nome_pt, :permalink_pt).order(:nome_pt).as_json(only: %i[id nome_pt permalink_pt])
    # Rails.cache.fetch("filter_cadernos", expires_in: 1.week) do
    # end
  end
end
