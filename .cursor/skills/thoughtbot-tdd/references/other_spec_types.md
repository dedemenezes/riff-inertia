# Reference: Request, View, Controller, Helper & Mailer Specs

Source: "Testing Rails" — thoughtbot

---

## Request Specs

Full-stack integration tests: route → controller → response.
Do not use Capybara — assert on status codes and response body.
Use for API design and any case where you care about the URL.

### Setup: json_body helper

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

### GET request

```ruby
# spec/requests/api/v1/links_spec.rb
require "rails_helper"

RSpec.describe "GET /api/v1/links" do
  it "returns a list of all links, hottest first" do
    coldest_link = create(:link)
    hottest_link = create(:link, upvotes: 2)

    get "/api/v1/links"

    expect(json_body["links"].count).to eq(2)

    hottest_link_json = json_body["links"][0]
    expect(hottest_link_json).to eq({
      "id"        => hottest_link.id,
      "title"     => hottest_link.title,
      "url"       => hottest_link.url,
      "upvotes"   => hottest_link.upvotes,
      "downvotes" => hottest_link.downvotes,
    })
  end
end
```

### POST request with traits

```ruby
RSpec.describe "POST /api/v1/links" do
  it "creates the link" do
    link_params = attributes_for(:link)

    post "/api/v1/links", link: link_params

    expect(response.status).to eq 201
    expect(Link.last.title).to eq link_params[:title]
  end

  context "when there are invalid attributes" do
    it "returns a 422, with errors" do
      link_params = attributes_for(:link, :invalid)  # uses :invalid trait

      post "/api/v1/links", link: link_params

      expect(response.status).to eq 422
      expect(json_body.fetch("errors")).not_to be_empty
    end
  end
end
```

**Note:** `attributes_for(:link)` returns a hash of factory attributes —
useful for simulating form/API params without persisting a record.

---

## View Specs

Use to test view logic in isolation. Avoids duplicating slow feature specs
when multiple scenarios have minor UI variations.

### Partial spec

```ruby
# spec/views/links/_link.html.erb_spec.rb
require "rails_helper"

RSpec.describe "links/_link.html.erb" do
  context "if the url is an image" do
    it "renders the image inline" do
      link = build(:link, url: "http://example.com/image.jpg")

      render partial: "links/link.html.erb", locals: { link: link }

      expect(rendered).to have_selector "img[src='#{link.url}']"
    end
  end
end
```

### Full view spec

```ruby
# spec/views/links/show.html.erb_spec.rb
require "rails_helper"

RSpec.describe "links/show.html.erb" do
  context "if the url is an image" do
    it "renders the image inline" do
      link = build(:link, url: "http://example.com/image.jpg")
      assign(:link, link)   # sets @link in the rendered view

      render               # RSpec infers view from describe block name

      expect(rendered).to have_selector "img[src='#{link.url}']"
    end
  end
end
```

**Key differences from partial spec:**
- `assign(:link, link)` sets the instance variable instead of a local
- `render` with no arguments — RSpec infers the template from `describe`

---

## Controller Specs

Use only when the controller has conditional logic. Prefer feature specs for
happy paths; controller specs for sad paths. Does not render views or hit routes.

### Sad path (re-render form)

```ruby
# spec/controllers/links_controller_spec.rb
require "rails_helper"

RSpec.describe LinksController, "#create" do
  context "when the link is invalid" do
    it "re-renders the form" do
      post :create, link: attributes_for(:link, :invalid)

      expect(response).to render_template :new
    end
  end
end
```

### Isolating the controller with a stub

```ruby
context "when the link is invalid" do
  it "re-renders the form" do
    invalid_link = double(save: false)
    allow(Link).to receive(:new).and_return(invalid_link)

    post :create, link: { attribute: "value" }

    expect(response).to render_template :new
  end
end
```

**Why isolate?** Changes to Link validations won't break this controller test.
The test now only fails if the controller stops re-rendering `:new` when `save`
returns false.

### Testing a side effect (sending email) — mocking style

```ruby
context "when the link is valid" do
  it "sends an email to the moderators" do
    valid_link = double(save: true)
    allow(Link).to receive(:new).and_return(valid_link)

    expect(LinkMailer).to receive(:new_link).with(valid_link)  # expectation before exercise

    post :create, link: { attribute: "value" }
  end
end
```

### Testing a side effect — spying style (preferred: follows four-phase)

```ruby
context "when the link is valid" do
  it "sends an email to the moderators" do
    valid_link = double(save: true)
    allow(Link).to receive(:new).and_return(valid_link)
    allow(LinkMailer).to receive(:new_link)         # setup stub

    post :create, link: { attribute: "value" }      # exercise

    expect(LinkMailer).to have_received(:new_link).with(valid_link)  # verify
  end
end
```

**Decision guide:**
- Forking logic = important distinct features → feature spec
- Care about URL → request spec
- Care about rendered content → request spec or view spec
- None of the above → controller spec or request spec

---

## Helper Specs

```ruby
# spec/helpers/application_helper_spec.rb
require "rails_helper"

RSpec.describe ApplicationHelper, "#formatted_score_for" do
  it "displays the net score along with the raw votes" do
    link = Link.new(upvotes: 7, downvotes: 2)

    formatted_score = helper.formatted_score_for(link)

    expect(formatted_score).to eq "5 (+7, -2)"
  end
end
```

**Notes:**
- Helpers are modules; RSpec provides the `helper` object that mixes in the
  described helper automatically.
- Use `Link.new` here — no need for persistence or FactoryGirl validity.

---

## Mailer Specs

### Integration level (controller spec — drive creation first)

```ruby
# spec/controllers/links_controller_spec.rb
context "when the link is valid" do
  it "sends an email to the moderators" do
    valid_link = double(save: true)
    allow(Link).to receive(:new).and_return(valid_link)
    allow(LinkMailer).to receive(:new_link)

    post :create, link: { attribute: "value" }

    expect(LinkMailer).to have_received(:new_link).with(valid_link)
  end
end
```

### Unit level (mailer spec — test the mailer itself)

```ruby
# Gemfile (:test group)
gem "email-spec"

# spec/mailers/link_mailer_spec.rb
require "rails_helper"

RSpec.describe LinkMailer, "#new_link" do
  it "delivers a new link notification email" do
    link = build(:link)

    email = LinkMailer.new_link(link)

    expect(email).to deliver_to(LinkMailer::MODERATOR_EMAILS)
    expect(email).to deliver_from("noreply@reddat.com")
    expect(email).to have_subject("New link submitted")
    expect(email).to have_body_text("A new link has been posted")
  end
end
```

**Matchers from `email-spec`:** `deliver_to`, `deliver_from`, `have_subject`, `have_body_text`.

**Implementation that satisfies the mailer spec:**
```ruby
# app/mailers/link_mailer.rb
class LinkMailer < ApplicationMailer
  MODERATOR_EMAILS = "moderators@example.com"

  default from: "noreply@reddat.com"

  def new_link(link)
    @link = link
    mail(to: MODERATOR_EMAILS, subject: "New link submitted")
  end
end
```
