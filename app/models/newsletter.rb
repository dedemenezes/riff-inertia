class Newsletter < ApplicationRecord
  EMAIL_REGEX = %r{[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?}
  self.record_timestamps = false # Disable default timestamping
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  before_create :set_created_timestamp
  before_save :set_updated_timestamp
  before_validation :strip_and_downcase_email

  private

  def strip_and_downcase_email
    return if email.empty? || email.nil?

    self.email = email.strip.downcase
  end

  def set_created_timestamp
    self.created ||= Time.current
  end

  def set_updated_timestamp
    self.updated = Time.current
  end
end
