# Sage/RSpec/NoEnvStubbing

Use ClimateControl instead of stubbing ENV in tests.

Stubbing ENV with `allow(ENV).to receive(...)` bypasses real ENV behavior and
can mask bugs. For example, `ENV.fetch("KEY", "default")` with a stub won't
actually exercise the default-value fallback logic. ClimateControl temporarily
sets real environment variables with automatic cleanup, giving more realistic
test coverage.

## Bad

```ruby
allow(ENV).to receive(:fetch).with("API_KEY").and_return("test_key")
allow(ENV).to receive(:[]).with("API_KEY").and_return("test_key")
allow(ENV).to receive(:fetch).and_call_original
```

## Good

```ruby
ClimateControl.modify(API_KEY: "test_key") do
  # test code
end

# In RSpec, use around block
around do |example|
  ClimateControl.modify(API_KEY: "test_key") do
    example.run
  end
end
```

## Configuration

```yaml
Sage/RSpec/NoEnvStubbing:
  Enabled: true
```

## Setup

Add to your Gemfile:

```ruby
gem 'climate_control'
```
