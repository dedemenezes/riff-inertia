# Reference: Model Specs

Source: "Testing Rails" — thoughtbot

Model specs test Rails models. They interact with the database (via ActiveRecord)
so they are not pure unit tests, but they are much faster than feature specs.

---

## Naming Convention

```ruby
RSpec.describe Link, "#upvote"       # instance method — prefix with #
RSpec.describe Link, ".hottest_first" # class method   — prefix with .
RSpec.describe Link, "validations"   # grouped validation tests
```

---

## Instance Method — build vs create

```ruby
# spec/models/link_spec.rb
RSpec.describe Link, "#upvote" do
  it "increments upvotes" do
    link = build(:link, upvotes: 1)  # build — no DB write needed here
    link.upvote
    expect(link.upvotes).to eq 2
  end
end
```

**Why `build` instead of `Link.new`?**
`link.upvote` will write to the DB, so the object must be valid.
Rather than manually satisfying every validation, rely on the factory as the
single source of truth for what makes a valid record.

**Implementation driven by this test:**
```ruby
# app/models/link.rb
def upvote
  increment!(:upvotes)
end
```

---

## Instance Method — no persistence needed

```ruby
RSpec.describe Link, "#score" do
  it "returns the upvotes minus the downvotes" do
    link = Link.new(upvotes: 2, downvotes: 1)  # plain .new is fine
    expect(link.score).to eq 1
  end
end
```

**Note:** Use `Link.new` when no database interaction is required and you only
need the attributes being tested. Skip FactoryGirl for simplicity.

**Implementation:**
```ruby
def score
  upvotes - downvotes
end
```

---

## Class Method — Scramble the Setup Data

```ruby
RSpec.describe Link, ".hottest_first" do
  it "returns the links: hottest to coldest" do
    coldest_link  = create(:link, upvotes: 3, downvotes: 3)
    hottest_link  = create(:link, upvotes: 5, downvotes: 1)
    lukewarm_link = create(:link, upvotes: 2, downvotes: 1)

    expect(Link.hottest_first).to eq [hottest_link, lukewarm_link, coldest_link]
  end
end
```

**Key:** Intentionally scramble creation order and choose numbers so the test
fails if the wrong attribute is sorted on. If the order matches by accident, the
test provides no value.

---

## Validations — shoulda-matchers

```ruby
# Gemfile (:test group)
gem "shoulda-matchers"

# spec/models/link_spec.rb
RSpec.describe Link, "validations" do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_uniqueness_of(:url) }
end
```

**`is_expected`** is shorthand for `expect(subject)`. RSpec instantiates
`subject` from the class passed to `describe` (i.e. `Link.new`).

Equivalent forms:
```ruby
it { expect(Link.new).to validate_presence_of(:title) }
it { expect(subject).to validate_presence_of(:url) }
it { is_expected.to validate_uniqueness_of(:url) }
```

**Note on associations:** Avoid testing associations with shoulda-matchers.
Associations are tested implicitly at the integration level (feature specs).

---

## Testing with a Collaborator (Score object)

When a model depends on a collaborator, prefer `instance_double` over `double`
so that interface mismatches are caught at test time.

```ruby
# spec/models/score_spec.rb
RSpec.describe Score do
  describe "#value" do
    it "is the difference between up and down votes" do
      link  = instance_double(Link, upvotes: 10, downvotes: 3)
      score = Score.new(link)
      expect(score.value).to eq 7
    end
  end

  describe "#controversial?" do
    it "is true when up/down votes are within 20% of each other" do
      link  = instance_double(Link, upvotes: 10, downvotes: 9)
      score = Score.new(link)
      expect(score).to be_controversial
    end

    it "is false when up/down votes differ by more than 20%" do
      link  = instance_double(Link, upvotes: 10, downvotes: 5)
      score = Score.new(link)
      expect(score).not_to be_controversial
    end
  end
end
```

**`instance_double(Link, ...)`** will raise an error if you stub a method that
`Link` does not actually implement — preventing phantom interfaces.

---

## FactoryGirl Quick Reference

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
end
```

| Method | Persisted? | Use when |
|---|---|---|
| `build(:link)` | No (associations yes) | Valid object, no DB query needed |
| `build_stubbed(:link)` | Nothing | Valid object, maximum speed |
| `create(:link)` | Yes | Test needs to query the DB |
| `attributes_for(:link)` | No | Need a hash of attributes (e.g. POST params) |
