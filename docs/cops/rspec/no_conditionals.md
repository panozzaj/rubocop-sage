# Sage/RSpec/NoConditionals

Avoid conditional statements in test examples for deterministic tests.

Conditional logic (if/unless/case) in tests obscures intent and indicates
non-deterministic behavior. Tests should have predictable, linear execution. If
you need conditional behavior, use context blocks to separate test cases.

## Bad

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

## Good

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

## Configuration

```yaml
Sage/RSpec/NoConditionals:
  Enabled: true
```
