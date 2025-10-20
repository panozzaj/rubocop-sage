# RuboCop Sage

Custom RuboCop cops for opinionated best practices in Ruby projects. Designed with clear, concise output suitable for LLM agents.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-sage', require: false
```

Or install it yourself:

```bash
gem install rubocop-sage
```

## Usage

Add to your `.rubocop.yml`:

```yaml
require:
  - rubocop-sage
```

## Cops

### Capybara

#### `Sage/Capybara/PreferNoMethods`

Use `has_no_*?` instead of `!has_*?` for Capybara matchers to handle asynchronous behavior correctly.

When using asynchronous drivers, negating `has_*?` methods can lead to false results because the check happens immediately without waiting. Capybara's `has_no_*?` methods properly wait for elements to disappear.

**Reference:** [Capybara documentation on asynchronous JavaScript](https://github.com/teamcapybara/capybara?tab=readme-ov-file#asynchronous-javascript-ajax-and-friends)

**Bad:**
```ruby
!page.has_xpath?('a')
!page.has_css?('.flash')
!page.has_selector?('.modal')
```

**Good:**
```ruby
page.has_no_xpath?('a')
page.has_no_css?('.flash')
page.has_no_selector?('.modal')
```

**Configuration:**
```yaml
Sage/Capybara/PreferNoMethods:
  Enabled: true
```

---

#### `Sage/Capybara/AvoidExplicitVisible`

Avoid explicit `visible: true` in Capybara matchers as it is the default behavior.

The `visible: true` option is redundant since it's the default. If you need to be explicit about visibility checking, consider whether the default behavior is sufficient or disable this cop selectively with comments.

**Bad:**
```ruby
expect(page).to have_selector('.container', visible: true)
expect(page).to have_no_selector('.container', visible: true)
page.has_css?('.container', visible: true)
```

**Good:**
```ruby
expect(page).to have_selector('.container')
expect(page).to have_no_selector('.container')
page.has_css?('.container')

# Acceptable when checking for invisible elements
expect(page).to have_selector('.container', visible: false)
expect(page).to have_selector('.container', visible: :all)
```

**Configuration:**
```yaml
Sage/Capybara/AvoidExplicitVisible:
  Enabled: true
```

**Disabling selectively:**
```ruby
# rubocop:disable Sage/Capybara/AvoidExplicitVisible
expect(page).to have_selector('.container', visible: true)
# rubocop:enable Sage/Capybara/AvoidExplicitVisible
```

---

#### `Sage/Capybara/NoWaitZero`

Avoid `wait: 0` in Capybara finders as it disables waiting and causes flaky tests.

Using `wait: 0` explicitly disables Capybara's waiting behavior, which leads to flaky tests. Elements may not be ready yet when the finder executes, causing intermittent failures especially in CI environments.

**Bad:**
```ruby
page.first('.navigation-menu', wait: 0).click
page.all('.items', wait: 0).count
page.find('.button', wait: 0)
```

**Good:**
```ruby
page.first('.navigation-menu').click
page.all('.items').count
page.find('.button')

# Acceptable - explicit positive wait time
page.first('.navigation-menu', wait: 5).click
```

**Configuration:**
```yaml
Sage/Capybara/NoWaitZero:
  Enabled: true
```

---

#### `Sage/Capybara/MatchStyle`

Prefer `first()` or `match: :first` over `all().first`, and verify count before using `all().last`.

Using `.first` or `.last` on the result of `.all()` can be flaky because the collection might not be fully loaded when you access it. For `.first`, use the `first()` finder method or `match: :first` option. For `.last`, verify the element count first.

**Bad:**
```ruby
page.all('.items').first
page.all('.items').first.click
page.all('.items').last  # Flaky: last element might not be loaded yet
```

**Good:**
```ruby
page.first('.items').click
page.all('.items', match: :first)

# For .last, verify count first
page.all('.items', minimum: 1).last
page.all('.items', count: 5).last
```

**Configuration:**
```yaml
Sage/Capybara/MatchStyle:
  Enabled: true
```

---

### RSpec

#### `Sage/RSpec/NoEnvAssignment`

Use ClimateControl to modify ENV in tests instead of direct assignment.

Direct ENV assignment modifies global state, which can affect other tests when you don't restore the original value. This is especially problematic when running tests in parallel threads, leading to flaky, hard-to-debug failures.

The ClimateControl gem provides a safe way to temporarily modify environment variables with automatic cleanup.

**Bad:**
```ruby
ENV['API_KEY'] = 'test_key'
ENV['RAILS_ENV'] = 'test'
```

**Good:**
```ruby
ClimateControl.modify(API_KEY: 'test_key') do
  # test code
end

# In RSpec, use around block
around do |example|
  ClimateControl.modify(API_KEY: 'test_key') do
    example.run
  end
end
```

**Configuration:**
```yaml
Sage/RSpec/NoEnvAssignment:
  Enabled: true
```

**Setup:**
Add to your Gemfile:
```ruby
gem 'climate_control'
```

---

#### `Sage/RSpec/NoConditionals`

Avoid conditional statements in test examples for deterministic tests.

Conditional logic (if/unless/case) in tests obscures intent and indicates non-deterministic behavior. Tests should have predictable, linear execution. If you need conditional behavior, use context blocks to separate test cases.

**Bad:**
```ruby
it 'processes the order' do
  if user.premium?
    expect(order.discount).to eq(20)
  else
    expect(order.discount).to eq(0)
  end
end

it 'clicks button if present' do
  button.click if page.has_css?('.submit-button')
end
```

**Good:**
```ruby
context 'when user is premium' do
  it 'applies discount' do
    expect(order.discount).to eq(20)
  end
end

context 'when user is not premium' do
  it 'does not apply discount' do
    expect(order.discount).to eq(0)
  end
end
```

**Configuration:**
```yaml
Sage/RSpec/NoConditionals:
  Enabled: true
```

---

#### `Sage/RSpec/NoRescue`

Avoid rescue blocks in test examples. Tests should fail loudly.

Using rescue in tests hides failures and makes tests pass when they should fail. Tests should fail loudly when something goes wrong. If you need to test error handling, use `expect { }.to raise_error(...)` instead.

**Bad:**
```ruby
it 'processes data' do
  begin
    process_data(invalid_input)
  rescue StandardError
    # silently ignore errors
  end
end

it 'saves record' do
  record.save rescue nil
end
```

**Good:**
```ruby
it 'raises an error for invalid input' do
  expect { process_data(invalid_input) }.to raise_error(ValidationError)
end

it 'saves the record' do
  expect(record.save).to be true
end
```

**Configuration:**
```yaml
Sage/RSpec/NoRescue:
  Enabled: true
```

---

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests.

## Philosophy

### Design for LLM Agents

This gem is designed with LLM agents in mind. All cop messages are:
- **Concise**: Get straight to the point
- **Clear**: Explain what and why without jargon
- **Actionable**: Provide the correct alternative

### Namespace Organization

Cops are organized by domain:
- `Sage/Capybara/*` - Capybara testing best practices
- `Sage/RSpec/*` - RSpec testing best practices
- `Sage/Rails/*` - Rails best practices (future)

### Avoiding Duplicates

Before adding a new cop, we check if an equivalent rule exists in popular RuboCop extensions (>100 GitHub stars). If one exists, we prefer using that instead.

**Recommended companion gems:**
- [`rubocop-capybara`](https://github.com/rubocop/rubocop-capybara) - Includes `Capybara/CurrentPathExpectation` (use `have_current_path` instead of asserting on `current_path` directly) and other useful Capybara cops
- [`rubocop-rspec`](https://github.com/rubocop/rubocop-rspec) - Comprehensive RSpec style checking

Example `.rubocop.yml` with recommended setup:
```yaml
require:
  - rubocop-sage
  - rubocop-capybara
  - rubocop-rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the MIT License.
