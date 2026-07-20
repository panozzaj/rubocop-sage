# RuboCop Sage

A collection of custom RuboCop cops.

These cops are primarily focused on:

 - preventing common coding agent shortcuts/hacks/antipatterns, especially in tests
 - reducing flaky test assertions
 - catching subtle bugs

Designed with clear, concise output suitable for both humans and LLM agents. And autocorrection where possible to keep your code moving along.

## Installation

Add to your Gemfile:

```ruby
gem 'rubocop-sage', github: 'panozzaj/rubocop-sage', require: false
```

Then `bundle install`.

## Usage

Add to your `.rubocop.yml`:

```yaml
plugins:
  - rubocop-sage
```

For RuboCop < 1.72, use `require:` instead of `plugins:`.

## Cops

<!-- Preference: Keep the README concise by linking to separate documentation files for each cop in ./docs -->

### Capybara

| Cop | Description | Autocorrect |
|-----|-------------|:-----------:|
| [`Sage/Capybara/AvoidExplicitVisible`](docs/cops/capybara/avoid_explicit_visible.md) | Avoid explicit `visible: true` as it is the default | Yes |
| [`Sage/Capybara/MatchStyle`](docs/cops/capybara/match_style.md) | Prefer `first()` over `all().first` for better reliability | No |
| [`Sage/Capybara/NoWaitZero`](docs/cops/capybara/no_wait_zero.md) | Avoid `wait: 0` which disables waiting and causes flaky tests | Yes |
| [`Sage/Capybara/PreferNoMethods`](docs/cops/capybara/prefer_no_methods.md) | Use `has_no_*?` instead of `!has_*?` for Capybara matchers | Yes |

### Minitest

| Cop | Description | Autocorrect |
|-----|-------------|:-----------:|
| [`Sage/Minitest/AvoidAssertNothingRaised`](docs/cops/minitest/avoid_assert_nothing_raised.md) | Avoid `assert_nothing_raised` — assert what the code *should do*, not that it doesn't crash | No |

### Rails

| Cop | Description | Autocorrect |
|-----|-------------|:-----------:|
| [`Sage/Rails/AllWithBlock`](docs/cops/rails/all_with_block.md) | `.all` ignores blocks; use `.find_each` or `.all.each` instead | No |

### RSpec

| Cop | Description | Autocorrect |
|-----|-------------|:-----------:|
| [`Sage/RSpec/AvoidNotToRaiseError`](docs/cops/rspec/avoid_not_to_raise_error.md) | Avoid `not_to raise_error` — assert what the code *should do*, not that it doesn't crash | No |
| [`Sage/RSpec/NoConditionals`](docs/cops/rspec/no_conditionals.md) | Avoid conditional statements in test examples | No |
| [`Sage/RSpec/NoEnvAssignment`](docs/cops/rspec/no_env_assignment.md) | Use ClimateControl instead of direct ENV assignment | No |
| [`Sage/RSpec/NoEnvStubbing`](docs/cops/rspec/no_env_stubbing.md) | Use ClimateControl instead of stubbing ENV with `allow`/`receive` | No |
| [`Sage/RSpec/NoRailsEnvStubbing`](docs/cops/rspec/no_rails_env_stubbing.md) | Don't stub `Rails.env`; use configuration instead | No |
| [`Sage/RSpec/NoRescue`](docs/cops/rspec/no_rescue.md) | Avoid rescue blocks in test examples | No |
| [`Sage/RSpec/PreferHaveHttpStatus`](docs/cops/rspec/prefer_have_http_status.md) | Use `have_http_status` instead of predicate matchers on response objects | Yes |
| [`Sage/RSpec/RedundantTypeAndEmpty`](docs/cops/rspec/redundant_type_and_empty.md) | Use `eq([])` or `eq({})` instead of separate type and emptiness checks | Yes |

## Philosophy

### Design for LLM Agents

All cop messages are concise, clear, and actionable — they explain what's wrong
and provide the correct alternative. This makes them useful as direct feedback
for LLM coding agents.

### Namespace Organization

Cops are organized by domain:

- `Sage/Capybara/*` — Capybara testing best practices
- `Sage/Minitest/*` — Minitest testing best practices
- `Sage/RSpec/*` — RSpec testing best practices
- `Sage/Rails/*` — Rails best practices

### Complementary Gems

Before adding a new cop, we check if an equivalent rule exists in established
RuboCop extensions. These gems work well alongside rubocop-sage:

- [`rubocop-capybara`](https://github.com/rubocop/rubocop-capybara)
- [`rubocop-minitest`](https://github.com/rubocop/rubocop-minitest)
- [`rubocop-rspec`](https://github.com/rubocop/rubocop-rspec)
- [`rubocop-rspec_rails`](https://github.com/rubocop/rubocop-rspec_rails)

## Development

```bash
bundle install
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/panozzaj/rubocop-sage).

## License

Available as open source under the [MIT License](LICENSE.txt).
