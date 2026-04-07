# Reference: RSpec Setup & Configuration

Source: "Testing Rails" — thoughtbot

---

## Installation

```bash
# Create new Rails app without Minitest
rails new myapp -T

# Or remove existing test directory
rm -rf /test
```

```ruby
# Gemfile — add to :development and :test groups
group :development, :test do
  gem "rspec-rails",        "~> 3.0"
  gem "factory_girl_rails"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "email-spec"
  gem "webmock"
end
```

```bash
bundle install
rails generate rspec:install
```

Generated files:
- `.rspec` — default CLI flags; `--require spec_helper` ensures spec_helper runs for every test
- `spec/spec_helper.rb` — RSpec config, no Rails dependency
- `spec/rails_helper.rb` — loads Rails; require in any spec that needs it

---

## rails_helper.rb key additions

```ruby
# spec/rails_helper.rb
require "capybara/rails"

# Auto-load all support files
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Block all external HTTP
WebMock.disable_net_connect!(allow_localhost: true)

# Set JS driver
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.use_transactional_fixtures = false  # required for DatabaseCleaner
end
```

---

## spec/support/ files

### factory_girl.rb
```ruby
# spec/support/factory_girl.rb
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint          # validates all factories before the suite runs
    ensure
      DatabaseCleaner.clean
    end
  end
end
```

### database_cleaner.rb
```ruby
# spec/support/database_cleaner.rb
RSpec.configure do |config|
  config.before(:suite)          { DatabaseCleaner.clean_with(:deletion) }
  config.before(:each)           { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :deletion }
  config.before(:each)           { DatabaseCleaner.start }
  config.after(:each)            { DatabaseCleaner.clean }
end
```

### api_helpers.rb
```ruby
# spec/support/api_helpers.rb
module ApiHelpers
  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :request
end
```

### env_helper.rb
```ruby
# spec/support/env_helper.rb
module EnvHelper
  def with_env(variable, value)
    old_value = ENV[variable]
    ENV[variable] = value
    yield
  ensure
    ENV[variable] = old_value
  end
end

RSpec.configure do |config|
  config.include EnvHelper
end
```

---

## factories.rb

```ruby
# spec/factories.rb
FactoryGirl.define do
  factory :link do
    title "Testing Rails"
    url   "http://testingrailsbook.com"

    trait :invalid do
      title nil
    end
  end

  factory :user do
    sequence(:username) { |n| "username#{n}" }
    password_digest "password"

    factory :subscriber do
      subscribed true
    end
  end

  factory :message do
    body "What's up?"

    trait :read do
      read_at { 1.month.ago }
    end
  end
end
```

---

## Running tests

```bash
rspec                           # run entire suite
rspec spec/models/link_spec.rb  # single file
rspec spec/models/link_spec.rb:34  # specific line
rspec --profile                 # show 10 slowest examples
rspec --seed 30205              # reproduce a specific random order
rspec --seed 30205 --bisect     # narrow down intermittent failure
```

---

## JavaScript: Database Cleaner behavior

- Default: `transaction` — fast, rolled back after each test
- JS specs (`:js`): `deletion` — required because real browsers run in a
  separate thread that cannot share the test's database transaction
- `truncation` — similar cost to deletion; use if deletion causes issues

---

## Coverage reports

```ruby
# Gemfile (:test)
gem "simplecov"

# spec/spec_helper.rb (top of file, before any other requires)
require "simplecov"
SimpleCov.start "rails"
```

Aim for 100% but watch for diminishing returns. Also minimize
"Hits / Line" — if a line is hit 50+ times, you may be over-testing that path.

---

## Continuous Integration tips

- Use CircleCI (or equivalent) to run the suite on every commit and every branch
- Integrate with GitHub pull requests to show green/red status before merging
- CI is not a substitute for running tests locally; slow-on-CI-only is a red flag
- Use CI for continuous deployment: auto-deploy green master builds
