class Newsletter < ApplicationRecord
  self.record_timestamps = false # Disable default timestamping

  validates :email, presence: true

  before_create :set_created_timestamp
  before_save :set_updated_timestamp

  private

  def set_created_timestamp
    self.created ||= Time.current
  end

  def set_updated_timestamp
    self.updated = Time.current
  end
end
