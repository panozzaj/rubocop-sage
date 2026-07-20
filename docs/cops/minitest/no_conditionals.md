# Sage/Minitest/NoConditionals

Avoid conditional statements in test methods for deterministic tests.

Conditional logic (if/unless/case) in tests obscures intent and indicates
non-deterministic behavior. Tests should have predictable, linear execution.
If you need conditional behavior, write separate test methods for each case.

## Bad

```ruby
def test_processes_order
  if user.premium?
    assert_equal 20, order.discount
  else
    assert_equal 0, order.discount
  end
end
```

## Good

```ruby
def test_premium_user_gets_discount
  assert_equal 20, order.discount
end

def test_regular_user_gets_no_discount
  assert_equal 0, order.discount
end
```

## Configuration

```yaml
Sage/Minitest/NoConditionals:
  Enabled: true
```
