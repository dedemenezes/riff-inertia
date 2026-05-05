class ApplicationRecord < ActiveRecord::Base
  # TODO: update to present year
  EDICAO_ATUAL_ANO = "2025"
  EDICAO_ATUAL_ID = 13
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

  # Legacy app owns the writes. Production runs read-only against the shared DB.
  # Models that genuinely need to write in production must override this.
  def readonly?
    Rails.env.production?
  end
end
