ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

require "nokogiri"
require "json"

module InertiaTestHelper
  def inertia_props
    html = Nokogiri::HTML(response.body)
    data_page = html.at_css("#app")&.attribute("data-page")&.value

    raise "No data-page found in response!" unless data_page

    JSON.parse(data_page)["props"]
  end
end

class ActionDispatch::IntegrationTest
  include InertiaTestHelper
end
