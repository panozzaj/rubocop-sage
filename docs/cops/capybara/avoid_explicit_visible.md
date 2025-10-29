# Sage/Capybara/AvoidExplicitVisible

Avoid explicit `visible: true` in Capybara matchers as it is the default
behavior.

The `visible: true` option is redundant since it's the default. If you need to
be explicit about visibility checking, consider whether the default behavior is
sufficient or disable this cop selectively with comments.

## Bad

```ruby
expect(page).to have_selector('.container', visible: true)
expect(page).to have_no_selector('.container', visible: true)
page.has_css?('.container', visible: true)
```

## Good

```ruby
expect(page).to have_selector('.container')
expect(page).to have_no_selector('.container')
page.has_css?('.container')

# Acceptable when checking for invisible elements
expect(page).to have_selector('.container', visible: false)
expect(page).to have_selector('.container', visible: :all)
```

## Configuration

```yaml
Sage/Capybara/AvoidExplicitVisible:
  Enabled: true
```
