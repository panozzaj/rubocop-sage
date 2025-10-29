# Sage/Capybara/NoWaitZero

Avoid `wait: 0` in Capybara finders as it disables waiting and causes flaky
tests.

Using `wait: 0` explicitly disables Capybara's waiting behavior, which leads to
flaky tests. Elements may not be ready yet when the finder executes, causing
intermittent failures especially in CI environments.

## Bad

```ruby
page.first('.navigation-menu', wait: 0).click
page.all('.items', wait: 0).count
page.find('.button', wait: 0)
```

## Good

```ruby
page.first('.navigation-menu').click
page.all('.items').count
page.find('.button')

# Acceptable - explicit positive wait time
page.first('.navigation-menu', wait: 5).click
```

## Configuration

```yaml
Sage/Capybara/NoWaitZero:
  Enabled: true
```
