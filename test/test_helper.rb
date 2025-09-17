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

class Minitest::Test
  def before_setup
    super

    # Save originals
    @old_ano    = ApplicationRecord::EDICAO_ATUAL_ANO
    @old_edicao = ApplicationRecord::EDICAO_ATUAL

    # Override for all tests
    ApplicationRecord.send(:remove_const, :EDICAO_ATUAL_ANO)
    ApplicationRecord.const_set(:EDICAO_ATUAL_ANO, "2024")

    ApplicationRecord.send(:remove_const, :EDICAO_ATUAL)
    ApplicationRecord.const_set(:EDICAO_ATUAL, 12)
  end

  def after_teardown
    super

    # Restore originals
    ApplicationRecord.send(:remove_const, :EDICAO_ATUAL_ANO)
    ApplicationRecord.const_set(:EDICAO_ATUAL_ANO, @old_ano)

    ApplicationRecord.send(:remove_const, :EDICAO_ATUAL)
    ApplicationRecord.const_set(:EDICAO_ATUAL, @old_edicao)
  end
end
