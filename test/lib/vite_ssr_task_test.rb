require "minitest/autorun"
require "rake"

class ViteSsrTaskTest < Minitest::Test
  def setup
    @original_rake_application = Rake.application
    Rake.application = Rake::Application.new
    Rake::Task.define_task("assets:precompile")

    load File.expand_path("../../lib/tasks/inertia_ssr.rake", __dir__)
  end

  def teardown
    Rake.application = @original_rake_application
  end

  def test_registers_vite_build_ssr_task
    assert Rake::Task.task_defined?("inertia:ssr:build")
  end

  def test_hooks_ssr_build_into_assets_precompile
    assert_equal 1, Rake::Task["assets:precompile"].actions.length
  end
end
