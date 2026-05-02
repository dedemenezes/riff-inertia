class ApplicationRecord < ActiveRecord::Base
  # TODO: update to present year
  EDICAO_ATUAL_ANO = "2024"
  EDICAO_ATUAL_ID = 12
  primary_abstract_class

  def self.timestamp_attributes_for_create
    ["created"]
  end

  def self.timestamp_attributes_for_update
    ["updated"]
  end
end
