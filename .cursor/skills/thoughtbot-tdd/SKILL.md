---
name: tdd-rails
description: >
  Use this skill when the user asks to write tests for a Rails application, practice
  TDD (Test Driven Development), set up RSpec, write feature/model/request/view/
  controller/helper/mailer specs, use FactoryGirl, handle test doubles/stubs/mocks,
  test external services, or fix test antipatterns. Trigger on keywords: RSpec,
  TDD, test suite, feature spec, model spec, Capybara, FactoryGirl, test double,
  stub, mock, outside-in, red green refactor, intermittent failure, slow tests.
source: "Testing Rails" by Josh Steiner and Joël Quenneville (thoughtbot)
---

# TDD Rails Skill

## Core Philosophy

Testing is about **saving time and money** and building **confidence**. Automated
tests catch regressions, provide a faster feedback loop than manual testing, and
serve as living documentation that is always up to date.

A test suite is only valuable if it is:
- **Fast** — run after every change; slow tests don't get run
- **Complete** — all public code paths covered
- **Reliable** — no false positives or intermittent failures
- **Isolated** — each test sets up and tears down its own state
- **Maintainable** — easy to add new tests and change existing ones
- **Expressive** — readable enough to serve as documentation

---

## The TDD Cycle: Red → Green → Refactor

1. **Red** — Write a failing test first. A failing test is a good sign; it proves the
   test is actually checking something.
2. **Green** — Write the *minimum* code to make the test pass. Be shameless.
   Return literal values if needed. Do not over-engineer.
3. **Refactor** — Clean up duplication in both production code and test code.
   Never skip this step.

**Key rule:** Only write code in response to a failing test's error message. Read
the error, fix only that error, re-run.

### Two TDD Approaches

| Approach | When to use |
|---|---|
| **Outside-In** | You understand the problem well. Start with a feature/acceptance test and let it drive you inward. Code doesn't work until the acceptance test is green — that's the signal you're done. |
| **Inside-Out** | You don't know what the end solution looks like. Build component by component, each fully working before moving up. |

---

## The Testing Pyramid

Build suites with three layers:

```
        [ Feature Specs ]        ← few, slow, high confidence
      [ Request / View Specs ]   ← medium, cover subsystems
  [ Model / Unit Specs ]         ← many, fast, fine-grained
```

Play to the strength of each layer. Feature specs catch integration gaps;
unit tests cover every edge case cheaply.

---

## Test Types Quick Reference

See `reference/` for full annotated examples of each type.

### Feature Specs (`spec/features/`)
- Simulate a real user in a browser via Capybara
- Use for happy paths through the application (outside-in start point)
- Move sad paths to controller or request specs to keep the suite fast
- Use `RSpec.feature` + `scenario` blocks
- Use `within`, `find`, `fill_in`, `click_on`, `expect(page).to have_*`

### Model Specs (`spec/models/`)
- Test instance methods, class methods, validations, and scopes
- Prefer `build` over `create`; prefer `build` over `Link.new` when you need a valid record
- Use `shoulda-matchers` for one-line validation tests
- Use `RSpec.describe ModelName, "#method_name"` naming convention
- Prefix instance methods with `#`, class methods with `.`

### Request Specs (`spec/requests/`)
- Full-stack integration: route → controller → response
- Use for API design; assert on status codes, response body structure
- Do not use Capybara — assert on `response.status`, `response.body`, `json_body`
- Extract `json_body` helper to `spec/support/api_helpers.rb`

### View Specs (`spec/views/`)
- Use when multiple tests would duplicate similar feature spec flows with minor variations
- Use `render`, `assign`, and assert on `rendered`
- Good for logic-heavy partials (e.g. conditional image rendering)

### Controller Specs (`spec/controllers/`)
- Use only when conditional logic exists in the controller
- Best for sad paths when a feature spec would be too slow
- Do not render views or hit routes; assert on `response` (status, template)
- Rule of thumb: feature specs for happy paths, controller specs for sad paths

### Helper Specs (`spec/helpers/`)
- Use the `helper` object provided by RSpec (automatically mixes in the described helper)
- Small scope, no side-effects — easy to test

### Mailer Specs (`spec/mailers/`)
- Unit-test with `email-spec` matchers: `deliver_to`, `deliver_from`, `have_subject`, `have_body_text`
- Drive creation at the integration level first (controller spec), then unit-test the mailer

---

## FactoryGirl

Factories > Fixtures. Factories are flexible, put important logic in the test, and
are easy to override.

### Golden rule
> Define only the **minimum attributes required for the model to pass validations**.
> Any extra attribute couples every test to data they don't care about.

### Initialization hierarchy (slowest last — use the earliest option that works)
1. `Object.new` — no validations, no FactoryGirl
2. `FactoryGirl.build_stubbed(:model)` — valid object, nothing persisted
3. `FactoryGirl.build(:model)` — valid object, associated records persisted
4. `FactoryGirl.create(:model)` — persisted; use only when you need a DB record

### Traits over named factories
Use traits to express state; avoid creating multiple factory definitions that act
like fixtures (`factory :pam`, `factory :michael`).

```ruby
factory :link do
  title "Testing Rails"
  url   "http://testingrailsbook.com"

  trait :invalid do
    title nil
  end
end
```

---

## Four Phase Test Pattern

Every test should be structured as:

```
setup    → create objects the test depends on
exercise → execute the functionality under test
verify   → assert on the result
teardown → handled by the framework (DatabaseCleaner, transactions)
```

Use blank lines between phases for readability.

---

## Testing in Isolation

### Test Doubles
Replace collaborators with `double(method: return_value)`.
Use `instance_double(ClassName, ...)` (verifying doubles) to catch interface mismatches at test time.

### Stubbing
Use `allow(obj).to receive(:method).and_return(value)` to intercept messages
to hard-coded collaborators.

### Mocking (set expectation before exercise)
```ruby
expect(LinkMailer).to receive(:new_link).with(valid_link)
post :create, link: { attribute: "value" }
```

### Spying (assert after exercise — preferred, follows four-phase pattern)
```ruby
allow(LinkMailer).to receive(:new_link)
post :create, link: { attribute: "value" }
expect(LinkMailer).to have_received(:new_link).with(valid_link)
```

### When to isolate vs. integrate
- Isolation is powerful but can produce a green suite with broken integration.
- Always pair unit tests with feature/integration specs that test the whole system.
- Do not isolate ActiveRecord models from the database — the pain isn't worth it.

---

## External Services

Never hit real external APIs in tests. Approaches in order of preference:

| Approach | Level | Notes |
|---|---|---|
| Stub the adapter | Unit | Fastest; encapsulate external calls in an adapter class first |
| Fake (Sinatra app) | Integration | Boots a real local server; closest to production |
| Webmock | Unit/Integration | Intercept HTTP; use `WebMock.disable_net_connect!` globally |
| VCR | Integration | Records and replays; expire cassettes regularly |
| Spy on external library | Unit | Only in the adapter's own tests |

**Always add** `WebMock.disable_net_connect!(allow_localhost: true)` to `rails_helper.rb`.

---

## Levels of Abstraction

Feature specs should read at a single level of abstraction — like pseudocode.
Use two techniques to achieve this:

### Extract Method
Pull low-level Capybara interactions into named helper methods. Put shared
helpers in `spec/support/` and include them via `RSpec.configure`.

### Page Objects
Encapsulate all interactions for a resource into a class that includes `Capybara::DSL`.
Predicate methods (`visible?`, `complete?`) become RSpec matchers (`be_visible`, `be_complete`).

---

## JavaScript Testing

- Tag JS scenarios with `:js`; set `Capybara.javascript_driver = :webkit` (or Poltergeist)
- Use DatabaseCleaner with `:deletion` strategy for JS specs (transactions don't cross threads)
- Always use `find` (with auto-wait) instead of `first` or `all` for async interactions
- Assert on UI changes after AJAX — Capybara matchers auto-wait up to 2 seconds
- Unit-test complex JS separately with Jasmine or Mocha; hook into Rake

---

## Continuous Integration

- CI runs the full suite on every commit in a clean environment
- CI is not a substitute for running tests locally
- Use CI for continuous deployment: auto-deploy all green master builds
- Add coverage reports (SimpleCov, Coveralls, Code Climate) but pursue 100% coverage with nuance

---

## Antipatterns to Avoid

See `reference/antipatterns.md` for annotated bad/good examples.

| Antipattern | Fix |
|---|---|
| Slow tests | Profile with `--profile`; use `build_stubbed`; move sad paths out of feature specs; don't hit external APIs |
| Intermittent failures | Run in random order; use DatabaseCleaner; reset global state with `ensure`; stub time with `travel_to` |
| Brittle tests | Decouple from copy via i18n; use `data-role` attributes; extract methods/page objects |
| Duplication | Refactor test code in the Refactor step; extract to `spec/support/` |
| Testing implementation details | Test inputs/outputs (behavior), not which internal methods are called |
| Private methods | Test indirectly via public interface; if hard, extract a new class |
| `let` / `before` overuse | Use plain Ruby variables and helper methods; assign in the test body |
| Bloated factories | Only define attributes required for validations |
| Fixtures-as-factories | Use traits and nested factories instead of named factory per-state |
| False positives | Always see the test fail first (Red step); comment out production code to verify |
| Stubbing the SUT | Extract the stubbed behavior to a new class; inject it as a dependency |
| Testing third-party code | Stub at the boundary; trust the library's own test suite |

---

## File Layout

```
spec/
  spec_helper.rb          # no Rails; loaded by every test
  rails_helper.rb         # loads Rails; require this in most specs
  factories.rb            # FactoryGirl definitions
  support/
    factory_girl.rb       # FactoryGirl config + DatabaseCleaner lint
    api_helpers.rb        # json_body helper for request specs
    env_helper.rb         # with_env for ENV variable stubbing
  features/
  models/
  requests/
  views/
  controllers/
  helpers/
  mailers/
```

Auto-load support files in `rails_helper.rb`:
```ruby
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
```
