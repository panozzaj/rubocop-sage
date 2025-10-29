# Sage/RSpec/NoRescue

Avoid rescue blocks in test examples. Tests should fail loudly.

Using rescue in tests hides failures and makes tests pass when they should fail.
Tests should fail loudly when something goes wrong. If you need to test error
handling, use `expect { }.to raise_error(...)` instead.

## Bad

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

## Good

```ruby
it 'raises an error for invalid input' do
  expect { process_data(invalid_input) }.to raise_error(ValidationError)
end

it 'saves the record' do
  expect(record.save).to be true
end
```

## Configuration

```yaml
Sage/RSpec/NoRescue:
  Enabled: true
```
