# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Capybara::MatchStyle, :config do
  let(:gem_versions) { { 'capybara' => '3.0' } }

  it 'registers an offense for all().first' do
    expect_offense(<<~RUBY)
      page.all('.items').first
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use `page.first(...)` or `match: :first` [...]
    RUBY
  end

  it 'registers an offense for all().first.click' do
    expect_offense(<<~RUBY)
      page.all('.items').first.click
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use `page.first(...)` or `match: :first` [...]
    RUBY
  end

  it 'registers an offense for all().last without count option' do
    expect_offense(<<~RUBY)
      page.all('.items').last
      ^^^^^^^^^^^^^^^^^^^^^^^ Verify element count before using `.last` [...]
    RUBY
  end

  it 'registers an offense for all().last.click without count option' do
    expect_offense(<<~RUBY)
      page.all('.items').last.click
      ^^^^^^^^^^^^^^^^^^^^^^^ Verify element count before using `.last` [...]
    RUBY
  end

  it 'registers an offense for find_all().first' do
    expect_offense(<<~RUBY)
      page.find_all('.items').first
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `page.first(...)` or `match: :first` [...]
    RUBY
  end

  it 'does not register an offense for first() method directly' do
    expect_no_offenses(<<~RUBY)
      page.first('.items').click
    RUBY
  end

  it 'does not register an offense for all() with match: :first' do
    expect_no_offenses(<<~RUBY)
      page.all('.items', match: :first)
    RUBY
  end

  it 'does not register an offense for all().last with count option' do
    expect_no_offenses(<<~RUBY)
      page.all('.items', count: 5).last
    RUBY
  end

  it 'does not register an offense for all().last with minimum option' do
    expect_no_offenses(<<~RUBY)
      page.all('.items', minimum: 1).last
    RUBY
  end

  it 'does not register an offense for all().last with maximum option' do
    expect_no_offenses(<<~RUBY)
      page.all('.items', maximum: 10).last
    RUBY
  end

  it 'does not register an offense for other methods on all()' do
    expect_no_offenses(<<~RUBY)
      page.all('.items').count
    RUBY
  end

  it 'does not register an offense for first/last on other objects' do
    expect_no_offenses(<<~RUBY)
      array.first
      array.last
    RUBY
  end
end
