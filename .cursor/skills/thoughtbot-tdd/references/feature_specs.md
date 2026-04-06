# Reference: Feature Specs

Source: "Testing Rails" — thoughtbot

Feature specs simulate a real user in a browser. They are acceptance tests.
Start here when practicing outside-in development.

---

## Setup

```ruby
# Gemfile
gem "capybara"

# spec/rails_helper.rb
require "capybara/rails"
```

---

## Basic Feature Spec (Happy Path)

```ruby
# spec/features/user_submits_a_link_spec.rb
require "rails_helper"

RSpec.feature "User submits a link" do
  scenario "they see the page for the submitted link" do
    # setup
    link_title = "This Testing Rails book is awesome!"
    link_url   = "http://testingrailsbook.com"

    # exercise
    visit root_path
    click_on "Submit a new link"
    fill_in "link_title", with: link_title
    fill_in "link_url",   with: link_url
    click_on "Submit!"

    # verify
    expect(page).to have_link link_title, href: link_url
  end
end
```

**Notes:**
- `RSpec.feature` is provided by Capybara.
- `scenario` description should complete the `feature` string as a sentence.
- `fill_in` finds by name, id, or label — no `#` prefix on ids.
- `have_link` checks text and `href`; powered by Capybara's `has_link?`.

---

## Sad Path in a Context Block

```ruby
# spec/features/user_submits_a_link_spec.rb
context "the form is invalid" do
  scenario "they see a useful error message" do
    link_title = "This Testing Rails book is awesome!"

    visit root_path
    click_on "Submit a new link"
    fill_in "link_title", with: link_title
    # intentionally omit URL
    click_on "Submit!"

    expect(page).to have_content "Url can't be blank"
  end
end
```

**Notes:**
- Test one sad path at integration level; test each field validation in model specs.
- `have_content` wraps Capybara's `has_content?` — ignores HTML tags.
- Avoid nesting `context` more than one or two levels deep.

---

## Feature Spec with FactoryGirl (Given State)

```ruby
# spec/features/user_views_homepage_spec.rb
require "rails_helper"

RSpec.feature "User views homepage" do
  scenario "they see existing links" do
    link = create(:link)   # setup via factory — do not re-test form submission

    visit root_path        # exercise

    expect(page).to have_link link.title, href: link.url  # verify
  end
end
```

**Notes:**
- Walking through Capybara is slow. If you've already tested a flow, use
  `create(:factory)` to set up state directly in the database instead.
- `create` is `FactoryGirl.create` included globally via `spec/support/factory_girl.rb`.

---

## Scoping with `within` and `data-role`

```ruby
# spec/features/user_upvotes_a_link_spec.rb
RSpec.feature "User upvotes a link" do
  scenario "they see an increased score" do
    link = create(:link)

    visit root_path

    within "#link_#{link.id}" do
      click_on "Upvote"
    end

    expect(page).to have_css "#link_#{link.id} [data-role=score]", text: "1"
  end
end
```

**Notes:**
- `within(selector)` scopes all finders to that element — avoids ambiguity with
  multiple links or buttons on the page.
- `[data-role=score]` decouples tests from CSS class names; designers can
  change markup freely as long as `data-role` attributes are preserved.

---

## JavaScript Scenarios

```ruby
feature "A user does something" do
  scenario "and sees a success message", :js do
    # test JS-driven interactions
  end
end
```

Configure in `rails_helper.rb`:
```ruby
Capybara.javascript_driver = :webkit
```

Use `find` (auto-waits up to 2 seconds) instead of `first`/`all` (return nil immediately):

```ruby
find(".modal-open").click
find(".confirm").click   # waits for modal to finish loading
```

Assert on UI changes after AJAX — do not sleep:
```ruby
click_on "Save"
expect(page).to have_css(".notice", text: "Document saved!")  # auto-waits
```

---

## Four Phase Test Pattern

```
test do
  setup    # create objects
  exercise # do the thing
  verify   # assert
  teardown # handled by DatabaseCleaner / transactions
end
```

Use blank lines between phases. Example:

```ruby
scenario "they see the page for the submitted link" do
  link_title = "This Testing Rails book is awesome!"  # setup
  link_url   = "http://testingrailsbook.com"

  visit root_path                                      # exercise
  click_on "Submit a new link"
  fill_in "link_title", with: link_title
  fill_in "link_url",   with: link_url
  click_on "Submit!"

  expect(page).to have_link link_title, href: link_url # verify
end
```

---

## Levels of Abstraction — Extract Method

```ruby
# BAD: mixed abstraction levels
scenario "updates todo as completed" do
  sign_in
  create_todo "Buy milk"
  find(".todos li", text: "Buy milk").click_on "Mark complete"
  expect(page).to have_css(".todos li.completed", text: "Buy milk")
end

# GOOD: single level of abstraction
scenario "updates todo as completed" do
  sign_in
  create_todo "Buy milk"
  mark_complete "Buy milk"
  expect(page).to have_completed_todo "Buy milk"
end

def mark_complete(name)
  find(".todos li", text: name).click_on "Mark complete"
end

def have_completed_todo(name)
  have_css(".todos li.completed", text: name)
end
```

---

## Levels of Abstraction — Page Objects

```ruby
# In the feature spec
scenario "complete my todos" do
  sign_in_as "person@example.com"
  todo = todo_on_page
  todo.create
  todo.mark_complete
  expect(todo).to be_complete
end

def todo_on_page
  TodoOnPage.new("Buy eggs")
end

# Page object class
class TodoOnPage
  include Capybara::DSL

  attr_reader :title

  def initialize(title)
    @title = title
  end

  def create
    click_link "Create a new todo"
    fill_in "Title", with: title
    click_button "Create"
  end

  def mark_complete
    todo_element.click_link "Complete"
  end

  def complete?
    todo_list.has_css? "li.complete", text: title
  end

  private

  def todo_element
    find "li", text: title
  end

  def todo_list
    find "ol.todos"
  end
end
```

`complete?` becomes `be_complete` via RSpec's predicate matcher magic.
