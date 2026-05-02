require "test_helper"

class ApplicationRecordTest < ActiveSupport::TestCase
  test "timestamp_attributes_for_create maps to 'created'" do
    assert_includes ApplicationRecord.timestamp_attributes_for_create, "created"
  end

  test "timestamp_attributes_for_update maps to 'updated'" do
    assert_includes ApplicationRecord.timestamp_attributes_for_update, "updated"
  end
end
