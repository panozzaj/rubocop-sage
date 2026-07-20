# Sage/RSpec/AvoidNotToRaiseError

Avoid `expect { ... }.not_to raise_error`. Assert what the code should do, not that it doesn't crash.

This pattern produces tests that pass for the wrong reasons and provide no
meaningful coverage of behavior. It is especially common when LLM coding agents
write a "red" test as "doesn't crash" — the test fails because the code crashes,
gets fixed, then passes because it no longer crashes. But the test never
verifies the actual behavior.

## Bad

```ruby
it 'processes the data' do
  expect { process_data(input) }.not_to raise_error
end

it 'processes the data' do
  expect { process_data(input) }.to_not raise_error
end

it 'processes the data' do
  expect { process_data(input) }.to_not raise_exception
end
```

## Good

```ruby
it 'processes the data' do
  expect(process_data(input)).to eq(expected_result)
end

it 'creates a record' do
  expect { process_data(input) }.to change(Record, :count).by(1)
end
```

## Configuration

```yaml
Sage/RSpec/AvoidNotToRaiseError:
  Enabled: true
```
