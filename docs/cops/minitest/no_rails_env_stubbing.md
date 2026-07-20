# Sage/Minitest/NoRailsEnvStubbing

Don't stub `Rails.env` in tests. Extract environment-dependent behavior behind configuration instead.

Stubbing `Rails.env` predicates creates inconsistent state: e.g.,
`Rails.env.production?` returns `true` while `Rails.env` still equals
`"test"`. Stubbing `Rails.env` itself is also fragile since the actual Rails
configuration, database, cache stores, etc. remain those of the test
environment.

## Bad

```ruby
# Minitest stub
Rails.stub(:env, 'production'.inquiry) do
  # test code
end

# Mocha
Rails.stubs(:env).returns('production'.inquiry)
Rails.env.stubs(:production?).returns(true)
```

## Good

```ruby
# Extract to configuration
MyApp.config.stub(:use_real_service?, true) do
  # test code
end
```

## Configuration

```yaml
Sage/Minitest/NoRailsEnvStubbing:
  Enabled: true
```
