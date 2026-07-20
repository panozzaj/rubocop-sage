# Sage/Minitest/AvoidAssertNothingRaised

Avoid `assert_nothing_raised`. Assert what the code should do, not that it doesn't crash.

This assertion checks that code "doesn't crash" rather than verifying what it
should actually do. It produces tests that pass for the wrong reasons and
provide no meaningful coverage of behavior. It is especially common when LLM
coding agents write a "red" test as "doesn't crash" — the test fails because
the code crashes, gets fixed, then passes because it no longer crashes. But the
test never verifies the actual behavior.

## Bad

```ruby
def test_processes_data
  assert_nothing_raised { process_data(input) }
end

def test_processes_data
  assert_nothing_raised(StandardError) { process_data(input) }
end
```

## Good

```ruby
def test_processes_data
  assert_equal expected_result, process_data(input)
end

def test_creates_record
  assert_difference('Record.count', 1) { process_data(input) }
end
```

## Configuration

```yaml
Sage/Minitest/AvoidAssertNothingRaised:
  Enabled: true
```
