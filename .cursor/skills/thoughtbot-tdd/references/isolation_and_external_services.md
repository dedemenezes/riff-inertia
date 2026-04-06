# Reference: Testing in Isolation & External Services

Source: "Testing Rails" — thoughtbot

---

## Testing in Isolation

### When to use real collaborators vs. doubles

| Situation | Approach |
|---|---|
| ActiveRecord models coupled to DB | Test with the real DB; isolation is too painful |
| Collaborator passed as a parameter | Use `double` or `instance_double` |
| Collaborator hard-coded inside the SUT | Stub with `allow(...).to receive(...)` |
| Side effect on a collaborator | Spy or mock on the collaborator |

---

## Test Doubles

```ruby
# Basic double — responds only to declared methods
link = double(upvotes: 10, downvotes: 3)

# Verifying double — raises if method not defined on Link
link = instance_double(Link, upvotes: 10, downvotes: 3)
```

If you stub a method that doesn't exist on `Link`:
```
Failure/Error: link = instance_double(Link, total_upvotes: 10, downvotes: 0)
Link does not implement: total_upvotes
```

**Prefer `instance_double`** — it prevents your doubles from drifting away from
the real interface as the class evolves.

---

## Stubbing

Intercept a message sent to a collaborator and return a canned response:

```ruby
allow(Link).to receive(:new).and_return(invalid_link)
```

Useful when the collaborator is hard-coded inside the object you're testing
(e.g. `Link.new` inside a controller action).

---

## Mocking (expectation set before exercise)

```ruby
expect(LinkMailer).to receive(:new_link).with(valid_link)
post :create, link: { attribute: "value" }
```

The expectation is verified at the end of the example. The downside is that
the assertion appears before the exercise step, breaking the four-phase pattern.

---

## Spying (preferred — follows four-phase pattern)

```ruby
# setup
allow(LinkMailer).to receive(:new_link)

# exercise
post :create, link: { attribute: "value" }

# verify
expect(LinkMailer).to have_received(:new_link).with(valid_link)
```

You can only spy on stubbed methods or test doubles. Spying on an unstubbed
method produces:

```
<LinkMailer (class)> expected to have received new_link,
but that object is not a spy or method has not been stubbed.
```

---

## External Services

Never hit real external APIs in tests. Reasons:
- Network is unreliable — tests can fail when the service is down, not your code
- Slow
- Rate limits
- No internet = no tests

### Block all external requests globally

```ruby
# spec/rails_helper.rb
WebMock.disable_net_connect!(allow_localhost: true)
```

---

### Adapter Pattern (recommended first step)

Encapsulate all external interaction in an adapter class. Your tests stub
the adapter; never stub the adapter in its own unit tests.

```ruby
class TwitterAdapter
  def self.tweet(message)
    new(ENV.fetch("TWITTER_API_KEY"), ENV.fetch("TWITTER_SECRET_TOKEN"))
      .tweet(message)
  end

  def initialize(api_key, secret_token)
    @client = Twitter::REST::Client.new do |config|
      config.access_token        = api_key
      config.access_token_secret = secret_token
    end
  end

  def tweet(message)
    @client.update(message)
  end
end
```

Stub the adapter in specs:
```ruby
describe "complete level" do
  it "posts to twitter" do
    allow(TwitterAdapter).to receive(:tweet).and_return(true)

    # exercise

    expect(TwitterAdapter).to have_received(:tweet).with(I18n.t(".success"))
  end
end
```

In the **adapter's own unit tests**, stub the external library instead:
```ruby
describe "complete level" do
  it "posts to twitter" do
    twitter = spy(:twitter)
    allow(Twitter::REST::Client).to receive(:new).and_return(twitter)

    # exercise

    expect(twitter).to have_received(:update).with(I18n.t(".success"))
  end
end
```

---

### Injecting a Fake Client (integration tests)

Write a fake client that records interactions instead of making real requests:

```ruby
module FakeSMS
  Message = Struct.new(:to, :from, :body)

  class Client
    def self.messages
      @messages ||= []
    end

    def send_message(to:, from:, body:)
      self.class.messages << Message.new(to, from, body)
    end
  end
end

# spec/rails_helper.rb
SMSClient.client = FakeSMS::Client
```

Use in a feature spec:
```ruby
feature "signing in" do
  scenario "with two factors" do
    user = create(:user, password: "password", email: "user@example.com")

    visit root_path
    click_on "Sign In"
    fill_in :email,    with: "user@example.com"
    fill_in :password, with: "password"
    click_on "Submit"

    last_message = FakeSMS.messages.last
    fill_in :code, with: last_message.body
    click_on "Submit"

    expect(page).to have_content("Sign out")
  end
end
```

---

### Webmock (intercept HTTP at the network layer)

```ruby
# Gemfile
gem "webmock"

describe QuoteOfTheDay, "#fetch" do
  it "fetches a quote via the API" do
    quote_text = "Victorious warriors win first..."
    stub_request(:get, "api.quotes.com/today")
      .with({ author: "Sun Tzu", quote: quote_text }.to_json)

    quote = QuoteOfTheDay.fetch

    expect(quote.author).to eq "Sun Tzu"
    expect(quote.text).to eq quote_text
  end
end
```

Use Webmock when you need to test how your adapter handles specific HTTP
responses (errors, edge cases). Use it at the unit level; prefer fakes at the
integration level.

---

### Fakes (Sinatra apps — best for integration)

```ruby
class FakeStripe < Sinatra::Base
  post "/v1/customers/:customer_id/subscriptions" do
    content_type :json
    customer_subscription.merge(
      id:       params[:id],
      customer: params[:customer_id]
    ).to_json
  end

  def customer_subscription
    # default subscription hash
  end
end

# spec/rails_helper.rb
Capybara::Discoball.spin(FakeStripe) do |server|
  url = "http://#{server.host}:#{server.port}"
  Stripe.api_base = url
end
```

The app makes real HTTP requests to the local fake — all application code runs,
including HTTP handling. Closest to production without hitting the real service.
Fakes can also be reused in development and staging environments.

---

### VCR (record and replay)

Records HTTP interactions to fixture files; replays them on subsequent runs.
Use when you need realistic API responses without writing them manually.

**Caution:** Cassettes go stale as APIs evolve. Auto-expire them every 1–2 weeks.

---

### Decision guide

| Level | Preferred approach |
|---|---|
| Unit (adapter's own tests) | Stub the external library |
| Unit (SUT that uses adapter) | Stub the adapter |
| Integration | Fake (Sinatra) or Webmock for one-off requests |
| Avoid | VCR (brittle, trades control for convenience) |

The real API can always change without tests breaking — they're not hitting it.
Verify against the real API in CI or staging manually.
