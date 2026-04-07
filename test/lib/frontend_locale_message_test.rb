# frozen_string_literal: true

require "test_helper"
class FrontendLocaleMessagesTest < ActiveSupport::TestCase
  test "serializes full locale tree with string keys" do
    I18n.with_locale(:en) do
      hash = FrontendLocaleMessages.as_json_hash
      assert_equal "Filters", hash.dig("filter", "title")
      assert_equal "The 26th edition of Festival do Rio is coming!", hash.dig("home", "banner_title")
    end
  end
  test "respects explicit locale" do
    hash = FrontendLocaleMessages.as_json_hash(:pt)
    assert_equal "Filtros", hash.dig("filter", "title")
  end
end
