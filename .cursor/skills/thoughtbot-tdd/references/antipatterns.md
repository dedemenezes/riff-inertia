# Reference: Antipatterns

Source: "Testing Rails" — thoughtbot

Each section shows the problem, explains why it matters, and provides the fix.

---

## 1. Slow Tests

### Profile to find culprits
```bash
rspec --profile       # shows 10 slowest tests
rspec --profile 4     # shows 4 slowest
```
Add to `.rspec` to always see this output.

### Use the right initialization method (slowest last)
```ruby
Object.new                          # fastest — no FactoryGirl, no DB
FactoryGirl.build_stubbed(:object)  # valid, nothing persisted
FactoryGirl.build(:object)          # valid, associated records persisted
FactoryGirl.create(:object)         # slowest — fully persisted
```
Only call `create` when you need to query the database for the record.

### Keep a fast spec_helper
```ruby
# spec/spec_helper.rb  — no Rails dependency
# spec/rails_helper.rb — requires Rails

# In a test that doesn't need Rails:
require "spec_helper"    # much faster to load
```

### Move sad paths out of feature specs
Feature specs are the slowest type. Test happy paths with feature specs;
move sad paths to controller, request, or view specs.

### Never hit external APIs
```ruby
# rails_helper.rb
WebMock.disable_net_connect!(allow_localhost: true)
```
Use fakes, Webmock, or VCR instead. If using VCR, expire cassettes regularly.

---

## 2. Intermittent Failures

### Run in random order; reproduce with seed
```bash
rspec                    # randomizes by default
rspec --seed 30205       # reproduce a specific order
rspec --seed 30205 --bisect  # narrow down the culprit
```

### Reset global state with `ensure`
```ruby
# spec/support/env_helper.rb
module EnvHelper
  def with_env(variable, value)
    old_value = ENV[variable]
    ENV[variable] = value
    yield
  ensure
    ENV[variable] = old_value  # always resets, even if test raises
  end
end

RSpec.configure do |config|
  config.include EnvHelper
end

# In a test:
with_env("POLLING_INTERVAL", "1") do
  # test code
end
```

### Stub time
```ruby
it "sets submitted_at to the current time" do
  form = Form.new
  travel_to Time.now do
    form.submit
    expect(form.reload.submitted_at).to eq Time.now
  end
end
```
Use `travel_to` (Rails 4.1+) or the `timecop` gem on older Rails.

### Database contamination (JavaScript specs)
```ruby
# rails_helper.rb
RSpec.configure do |config|
  config.use_transactional_fixtures = false  # disable for JS compat

  config.before(:suite)      { DatabaseCleaner.clean_with(:deletion) }
  config.before(:each)       { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :deletion }
  config.before(:each)       { DatabaseCleaner.start }
  config.after(:each)        { DatabaseCleaner.clean }
end
```

---

## 3. Brittle Tests

### Coupling to copy — BAD
```ruby
expect(page).to have_content "Welcome, #{user.name}"
# Breaks if a designer changes "Welcome" to "Hello again"
```

### Fix with i18n
```erb
<%# view %>
<p><%= t("dashboards.show.welcome", user: current_user) %></p>
```
```ruby
# test
expect(page).to have_content t("dashboards.show.welcome", user: user)
```
Copy changes go only to the YAML file — no test or template changes needed.

### Fix with data-role attributes
```html
<div class="warning" data-role="warning">
  <p>This is a warning</p>
</div>
```
```ruby
expect(page).to have_css "[data-role=warning]"
# CSS classes can change freely; data-role is stable
```

---

## 4. Testing Implementation Details

### BAD — tests how, not what
```ruby
describe "#absolute_value" do
  it "checks if the number is negative" do
    number = 5
    allow(number).to receive(:negative?)
    absolute_value(number)
    expect(number).to have_received(:negative?)
  end
end
# Breaks if you refactor to use `number < 0` directly
```

### GOOD — tests behavior (inputs/outputs)
```ruby
describe "#absolute_value" do
  it "returns the number's distance from zero" do
    expect(absolute_value(4)).to  eq 4
    expect(absolute_value(0)).to  eq 0
    expect(absolute_value(-2)).to eq 2
  end
end
# Can refactor internals freely
```

### Testing repeated implementation logic — BAD
```ruby
describe Item, ".unique_names" do
  it "returns sorted unique names" do
    # ...setup...
    expected = Item.pluck(:name).uniq.sort  # duplicates the production logic!
    expect(Item.unique_names).to eq expected
  end
end
```

### GOOD — assert on concrete expected values
```ruby
describe Item, ".unique_names" do
  it "returns sorted unique names" do
    create(:item, name: "Gamma")
    create(:item, name: "Gamma")
    create(:item, name: "Alpha")
    create(:item, name: "Beta")

    expect(Item.unique_names).to eq %w(Alpha Beta Gamma)
  end
end
```

---

## 5. Private Methods

Do not test private methods directly. Test them indirectly through public methods.
If the logic is complex enough to need independent testing, extract it to its own class.

---

## 6. Overusing `let`, `let!`, and `before`

### Problems
- Mystery Guest: dependencies are defined far from the test; hard to know what each test needs.
- Hidden coupling: changing a `let` silently affects all tests in the group.
- `let!` runs for every test in the context — can slow tests and introduce unexpected state.

### BAD — with `let`
```ruby
describe RepoActivator, "#deactivate" do
  let(:repo)      { create(:repo) }
  let!(:github_api) { ... }   # runs before EVERY test in this group
  # ... many tests below that scroll off screen ...
end
```

### GOOD — plain Ruby in the test body
```ruby
describe RepoActivator, "#deactivate" do
  context "when repo deactivation succeeds" do
    it "marks repo as deactivated" do
      repo      = create(:repo)
      activator = build_activator(repo: repo)
      stub_github_api

      activator.deactivate

      expect(repo.reload).not_to be_active
    end

    it "removes GitHub hook" do
      repo       = create(:repo)
      activator  = build_activator(repo: repo)
      github_api = stub_github_api

      activator.deactivate

      expect(github_api).to have_received(:remove_hook)
    end
  end

  def build_activator(repo: build(:repo))
    allow(RemoveHoundFromRepo).to receive(:run)
    allow(AddHoundToRepo).to receive(:run).and_return(true)
    RepoActivator.new(github_token: "githubtoken", repo: repo)
  end

  def stub_github_api
    hook = double(:hook, id: 1)
    api  = double(:github_api, remove_hook: true)
    allow(api).to receive(:create_hook).and_yield(hook)
    allow(GithubApi).to receive(:new).and_return(api)
    api
  end
end
```
Each test is self-contained. Helper methods are available but assignment
happens inside the test, so every dependency is visible.

---

## 7. Bloated Factories

### BAD — optional attributes pollute every test
```ruby
factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"
  name "Donald Duck"   # optional — why is this here?
  age  24              # optional — now every test using :user gets this
end
```

### GOOD — minimum required for validations
```ruby
factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"
end
```

---

## 8. Using Factories Like Fixtures

### BAD — named factories per state (slow + inflexible)
```ruby
factory :pam, class: User do
  name "Pam"
  manager false
end

factory :michael, class: User do
  name "Michael"
  manager true
end
```

### GOOD — use traits
```ruby
factory :message do
  body "What's up?"

  trait :read do
    read_at { 1.month.ago }
  end
end

# In the test — intent is explicit
build_stubbed(:message, :read)
```

### GOOD — use nested factories for inheritance
```ruby
factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"

  factory :subscriber do
    subscribed true
  end
end

build_stubbed(:subscriber)   # clear and concise
```

---

## 9. False Positives

Always follow Red → Green → Refactor. If you write production code before the
test, comment out the production code, write the test, see it fail, then uncomment.

A test that was never seen to fail cannot be trusted.

---

## 10. Stubbing the System Under Test

### BAD — stubbing a private method on the SUT
```ruby
describe CreditCard, "#create_charge" do
  it "returns transaction IDs on success" do
    credit_card = CreditCard.new("4111")
    expected    = double("expected")
    allow(credit_card).to receive(:create_transaction)  # stubbing the SUT
      .with("/cards/4111/charges", amount: 100)
      .and_return(expected)
    result = credit_card.create_charge(100)
    expect(result).to eq(expected)
  end
end
```

### GOOD — extract the behavior to its own class; inject it as a dependency
```ruby
describe CreditCard, "#create_charge" do
  it "returns transaction IDs on success" do
    expected       = double("expected")
    gateway_client = double("gateway_client")
    allow(gateway_client).to receive(:post)
      .with("/cards/4111/charges", amount: 100)
      .and_return(expected)

    credit_card = CreditCard.new(gateway_client, "4111")
    result = credit_card.create_charge(100)

    expect(result).to eq(expected)
  end
end
```

Refactored production code:
```ruby
class CreditCard
  def initialize(client, id)
    @id     = id
    @client = client
  end

  def create_charge(amount)
    @client.post("/cards/#{@id}/charges", amount: amount)
  end
end

class GatewayClient
  def post(path, data = {})
    # HTTP implementation here
  end
end
```

---

## 11. Testing Code You Don't Own

### BAD — testing the library, not your code
```ruby
describe "#save" do
  it "saves the user" do
    user = User.new
    user.save
    expect(user).to eq User.find(user.id)  # testing ActiveRecord, not your code
  end
end
```

### BAD — testing that the gem makes HTTP requests
```ruby
describe "#publish" do
  it "publishes to twitter" do
    new_tweet_request = stub_request(:post, "api.twitter.com/tweets")
    service = PublishService.new
    service.publish("message")
    expect(new_tweet_request).to have_been_requested  # testing the twitter gem
  end
end
```

### GOOD — stub at the boundary of third-party code
```ruby
describe "#publish" do
  it "publishes to twitter" do
    client = double(publish: nil)
    allow(Twitter::REST::Client).to receive(:new).and_return(client)

    service = PublishService.new
    service.publish("message")

    expect(client).to have_received(:publish).with("message")
  end
end
```
Test that your code sends the right message to the library. Trust the library's
own test suite to verify what happens next.
