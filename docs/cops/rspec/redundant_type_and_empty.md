# Sage/RSpec/RedundantTypeAndEmpty

Use `eq([])` or `eq({})` instead of separate type and emptiness checks.

When checking that a value is an empty array or hash, directly asserting the
value with `eq([])` or `eq({})` is clearer and more concise than two separate
expectations for type and emptiness.

## Bad

```ruby
expect(json["items"]).to be_an(Array)
expect(json["items"]).to be_empty

expect(data).to be_a(Hash)
expect(data).to be_empty

# Also catches reversed order
expect(json["items"]).to be_empty
expect(json["items"]).to be_an(Array)
```

## Good

```ruby
expect(json["items"]).to eq([])

expect(data).to eq({})
```

## Why?

- **More concise**: One expectation instead of two
- **Clearer intent**: Directly states what the value should be
- **Easier to read**: `eq([])` is more idiomatic in RSpec

## Configuration

```yaml
Sage/RSpec/RedundantTypeAndEmpty:
  Enabled: true
```

## Auto-correction

This cop supports auto-correction. It will:

1. Replace the first expectation with `eq([])` or `eq({})`
2. Remove the second expectation entirely
3. Clean up any whitespace or comments between the two expectations
