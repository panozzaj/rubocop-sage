# RuboCop Sage

Custom RuboCop cops for opinionated best practices in Ruby projects. Designed
with clear, concise output suitable for LLM agents.

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

<!-- Preference: Keep the README concise by linking to separate documentation files for each cop in ./docs -->

### Capybara

- [`Sage/Capybara/PreferNoMethods`](docs/cops/capybara/prefer_no_methods.md) -
  Use `has_no_*?` instead of `!has_*?` for Capybara matchers
- [`Sage/Capybara/AvoidExplicitVisible`](docs/cops/capybara/avoid_explicit_visible.md) -
  Avoid explicit `visible: true` as it is the default
- [`Sage/Capybara/NoWaitZero`](docs/cops/capybara/no_wait_zero.md) - Avoid
  `wait: 0` which disables waiting and causes flaky tests
- [`Sage/Capybara/MatchStyle`](docs/cops/capybara/match_style.md) - Prefer
  `first()` over `all().first` for better reliability

### RSpec

- [`Sage/RSpec/NoEnvAssignment`](docs/cops/rspec/no_env_assignment.md) - Use
  ClimateControl instead of direct ENV assignment
- [`Sage/RSpec/NoConditionals`](docs/cops/rspec/no_conditionals.md) - Avoid
  conditional statements in test examples
- [`Sage/RSpec/NoRescue`](docs/cops/rspec/no_rescue.md) - Avoid rescue blocks in
  test examples

## Development

After checking out the repo, run `bundle install` to install dependencies. Then,
run `bundle exec rspec` to run the tests.

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

Before adding a new cop, we check if an equivalent rule exists in popular
RuboCop extensions (> 100 GitHub stars). If one exists, we prefer using that
instead.

**Recommended companion gems:**

- [`rubocop-capybara`](https://github.com/rubocop/rubocop-capybara) - Includes
  `Capybara/CurrentPathExpectation` (use `have_current_path` instead of
  asserting on `current_path` directly) and other useful Capybara cops
- [`rubocop-rspec`](https://github.com/rubocop/rubocop-rspec) - Comprehensive
  RSpec style checking

Example `.rubocop.yml` with recommended setup:

```yaml
require:
  - rubocop-sage
  - rubocop-capybara
  - rubocop-rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at the repository location.

## License

The gem is available as open source under the terms of the MIT License.
