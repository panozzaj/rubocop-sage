# Sage/Capybara/PreferNoMethods

Use `has_no_*?` instead of `!has_*?` for Capybara matchers to handle
asynchronous behavior correctly.

When using asynchronous drivers, negating `has_*?` methods can lead to false
results because the check happens immediately without waiting. Capybara's
`has_no_*?` methods properly wait for elements to disappear.

**Reference:**
[Capybara documentation on asynchronous JavaScript](https://github.com/teamcapybara/capybara?tab=readme-ov-file#asynchronous-javascript-ajax-and-friends)

## Bad

```ruby
!page.has_xpath?('a')
!page.has_css?('.flash')
!page.has_selector?('.modal')
```

## Good

```ruby
page.has_no_xpath?('a')
page.has_no_css?('.flash')
page.has_no_selector?('.modal')
```

## Configuration

```yaml
Sage/Capybara/PreferNoMethods:
  Enabled: true
```
