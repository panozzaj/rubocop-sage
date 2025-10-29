# Sage/Capybara/MatchStyle

Prefer `first()` or `match: :first` over `all().first`, and verify count before
using `all().last`.

Using `.first` or `.last` on the result of `.all()` can be flaky because the
collection might not be fully loaded when you access it. For `.first`, use the
`first()` finder method or `match: :first` option. For `.last`, verify the
element count first.

## Bad

```ruby
page.all('.items').first
page.all('.items').first.click
page.all('.items').last  # Flaky: last element might not be loaded yet
```

## Good

```ruby
page.first('.items').click
page.all('.items', match: :first)

# For .last, verify count first
page.all('.items', minimum: 1).last
page.all('.items', count: 5).last
```

## Configuration

```yaml
Sage/Capybara/MatchStyle:
  Enabled: true
```
