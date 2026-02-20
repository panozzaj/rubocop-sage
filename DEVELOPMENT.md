# Development Guide

## Testing Conventions

### RuboCop Offense Markers

When writing tests for cops using `expect_offense`, use RuboCop's variable
interpolation to avoid manual caret counting:

1. **Use `%{var}` / `^{var}` interpolation**: This automatically generates the
   correct number of carets matching the interpolated string width.

   ```ruby
   # Full-line offense (offense spans entire line)
   expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:fetch)')
     %{code}
     ^{code} Use ClimateControl.modify [...]
   RUBY

   # Prefix offense (offense is a prefix of the line)
   expect_offense(<<~RUBY, code: 'User.all')
     %{code} do |user|
     ^{code} `.all` ignores blocks. [...]
   RUBY

   # Mid-line offense (offense starts partway through a line)
   expect_offense(<<~RUBY, rescue_clause: 'rescue nil')
     it 'saves' do
       record.save %{rescue_clause}
                   ^{rescue_clause} Avoid rescue [...]
     end
   RUBY
   ```

2. **Manual carets for fixed-width sub-expressions**: When the offense is always
   the same width (e.g., `visible: true`, `wait: 0`), manual carets are fine.

   ```ruby
   expect_offense(<<~RUBY)
     page.has_css?('.container', visible: true)
                                 ^^^^^^^^^^^^^ Avoid explicit `visible: true` [...]
   RUBY
   ```

3. **Abbreviate messages with `[...]`**: Use `[...]` to abbreviate the full
   offense message in tests. This makes tests more maintainable when message
   wording changes.

### Test Setup

All specs use the `:config` shared context (from the `describe` metadata).
Override `gem_versions` to match the cop's `requires_gem` declaration:

```ruby
RSpec.describe RuboCop::Cop::Sage::Capybara::SomeCop, :config do
  let(:gem_versions) { { 'capybara' => '3.0' } }
  # ...
end
```

### Test Organization

- Group related test cases together
- Use descriptive test names that explain what's being tested
- Include both positive tests (registers offense) and negative tests (does not
  register offense)
- Test edge cases: helper methods, nested blocks, different RSpec example types
  (it/specify/example/scenario)
