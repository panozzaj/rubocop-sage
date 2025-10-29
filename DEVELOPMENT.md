# Development Guide

## Testing Conventions

### RuboCop Offense Markers

When writing tests for cops using `expect_offense`, follow these conventions:

1. **Use full caret patterns**: Mark the full width of the offense location with
   `^` characters

   ```ruby
   expect_offense(<<~RUBY)
     if user.premium?
     ^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
   RUBY
   ```

2. **Abbreviate messages with `[...]`**: Use `[...]` to abbreviate the full
   offense message in tests
   - This makes tests more maintainable when message wording changes
   - The `[...]` tells RuboCop to match any text after that point
   - Example: `Avoid conditionals [...]` matches the full message "Avoid
     conditionals in tests. Use context blocks to separate test cases for
     clarity and determinism."

3. **Count carets literally**: The number of `^` characters should match the
   exact width of the offense location
   - Don't use variables like `^{node}` - just count the literal characters
   - This ensures tests accurately reflect where the offense is detected

### Example Test Pattern

```ruby
it 'registers an offense for if statement' do
  expect_offense(<<~RUBY)
    it 'processes data' do
      if condition
      ^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
        process_data
      end
    end
  RUBY
end
```

### Test Organization

- Group related test cases together
- Use descriptive test names that explain what's being tested
- Include both positive tests (registers offense) and negative tests (does not
  register offense)
- Test edge cases: helper methods, nested blocks, different RSpec example types
  (it/specify/example/scenario)
