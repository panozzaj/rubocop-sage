# Sage/RSpec/NoRailsEnvStubbing

Don't stub `Rails.env` in tests. Extract environment-dependent behavior behind
configuration instead.

Stubbing predicates on `Rails.env` (e.g.,
`allow(Rails.env).to receive(:production?).and_return(true)`) creates
inconsistent state: `Rails.env.production?` returns `true` while `Rails.env`
still equals `"test"`. Code that checks the environment via a different
predicate or string comparison will see the real environment.

Stubbing `Rails.env` itself is also fragile since the actual Rails
configuration, database connections, cache stores, etc. remain those of the test
environment.

## Bad

```ruby
allow(Rails.env).to receive(:production?).and_return(true)
allow(Rails.env).to receive(:test?).and_return(false)
allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
```

## Good

Extract environment-dependent behavior behind configuration:

```ruby
# In application code, instead of:
#   if Rails.env.production?
#     send_to_real_service
#   end
#
# Use:
#   if MyApp.config.use_real_service?
#     send_to_real_service
#   end

# Then in tests:
allow(MyApp.config).to receive(:use_real_service?).and_return(true)
```

## Configuration

```yaml
Sage/RSpec/NoRailsEnvStubbing:
  Enabled: true
```
