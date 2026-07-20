# Sage/Minitest/NoEnvAssignment

Use ClimateControl.modify to change ENV in tests instead of direct assignment.

Direct ENV assignment modifies global state, which can affect other tests when
you don't restore the original value. This is especially problematic when
running tests in parallel threads, leading to flaky, hard-to-debug failures.

The ClimateControl gem provides a safe way to temporarily modify environment
variables with automatic cleanup.

## Bad

```ruby
def test_something
  ENV['API_KEY'] = 'test_key'
  # ...
end

def setup
  ENV['RAILS_ENV'] = 'test'
end
```

## Good

```ruby
def test_something
  ClimateControl.modify(API_KEY: 'test_key') do
    # test code
  end
end
```

## Configuration

```yaml
Sage/Minitest/NoEnvAssignment:
  Enabled: true
```
