# Sage/Minitest/NoRescue

Avoid rescue blocks in test methods. Tests should fail loudly.

Using rescue in tests hides failures and makes tests pass when they should fail.
Tests should fail loudly when something goes wrong. If you need to test error
handling, use `assert_raises(ErrorClass)` instead.

## Bad

```ruby
def test_processes_data
  begin
    process_data(invalid_input)
  rescue StandardError
    # silently ignore errors
  end
end

def test_saves_record
  record.save rescue nil
end
```

## Good

```ruby
def test_raises_for_invalid_input
  assert_raises(ValidationError) { process_data(invalid_input) }
end

def test_saves_record
  assert record.save
end
```

## Configuration

```yaml
Sage/Minitest/NoRescue:
  Enabled: true
```
