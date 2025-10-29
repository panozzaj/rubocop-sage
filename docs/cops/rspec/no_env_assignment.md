# Sage/RSpec/NoEnvAssignment

Use ClimateControl to modify ENV in tests instead of direct assignment.

Direct ENV assignment modifies global state, which can affect other tests when
you don't restore the original value. This is especially problematic when
running tests in parallel threads, leading to flaky, hard-to-debug failures.

The ClimateControl gem provides a safe way to temporarily modify environment
variables with automatic cleanup.

It's also useful for ensuring that local tests run correctly even when certain
ENV variables are set or not set in the developer's environment.

## Bad

```ruby
ENV['API_KEY'] = 'test_key'
ENV['RAILS_ENV'] = 'test'
```

## Good

```ruby
ClimateControl.modify(API_KEY: 'test_key') do
  # test code
end

# In RSpec, use around block
around do |example|
  ClimateControl.modify(API_KEY: 'test_key') do
    example.run
  end
end
```

## Configuration

```yaml
Sage/RSpec/NoEnvAssignment:
  Enabled: true
```

## Setup

Add to your Gemfile:

```ruby
gem 'climate_control'
```
