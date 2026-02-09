# Sage/Rails/AllWithBlock

## Description

`ActiveRecord::Base.all` returns a relation and does not yield to a block.
Passing a block to `.all` is silently ignored, which is almost certainly a bug.
The author likely meant `.all.each` or `.find_each`.

## Examples

### Bad

```ruby
User.all do |user|
  user.do_something
end

User.all { |user| user.do_something }

User.active.all do |user|
  user.notify
end
```

### Good

```ruby
User.find_each do |user|
  user.do_something
end

User.all.each do |user|
  user.do_something
end
```

## Why `.find_each`?

For large datasets, `.find_each` is preferred over `.all.each` because it loads
records in batches (default 1000) instead of loading everything into memory at
once.
