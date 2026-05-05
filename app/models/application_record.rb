class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.timestamp_attributes_for_create
    [ "created" ]
  end

  def self.timestamp_attributes_for_update
    [ "updated" ]
  end

  def self.inherited(subclass)
    super
    subclass.class_eval do
      attribute :ativo, :boolean if column_names.include?("ativo")
    rescue ActiveRecord::ActiveRecordError, NotImplementedError
      # table may not exist during migrations
    end
  end
end
