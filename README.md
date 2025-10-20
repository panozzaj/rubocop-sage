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
