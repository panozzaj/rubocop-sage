# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Capybara::NoWaitZero, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for first with wait: 0' do
    expect_offense(<<~RUBY)
      page.first('.navigation-menu', wait: 0).click
                                     ^^^^^^^ Sage/Capybara/NoWaitZero: Avoid `wait: 0` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.first('.navigation-menu').click
    RUBY
  end

  it 'registers an offense for all with wait: 0' do
    expect_offense(<<~RUBY)
      page.all('.items', wait: 0).count
                         ^^^^^^^ Sage/Capybara/NoWaitZero: Avoid `wait: 0` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.all('.items').count
    RUBY
  end

  it 'registers an offense for find with wait: 0' do
    expect_offense(<<~RUBY)
      page.find('.button', wait: 0)
                           ^^^^^^^ Sage/Capybara/NoWaitZero: Avoid `wait: 0` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.find('.button')
    RUBY
  end

  it 'registers an offense for wait: 0 with other options' do
    expect_offense(<<~RUBY)
      page.first('.menu', visible: true, wait: 0)
                                         ^^^^^^^ Sage/Capybara/NoWaitZero: Avoid `wait: 0` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.first('.menu', visible: true)
    RUBY
  end

  it 'registers an offense for wait: 0 as first option' do
    expect_offense(<<~RUBY)
      page.all('.items', wait: 0, minimum: 1)
                         ^^^^^^^ Sage/Capybara/NoWaitZero: Avoid `wait: 0` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.all('.items', minimum: 1)
    RUBY
  end

  it 'does not register an offense for first without wait option' do
    expect_no_offenses(<<~RUBY)
      page.first('.navigation-menu').click
    RUBY
  end

  it 'does not register an offense for all without wait option' do
    expect_no_offenses(<<~RUBY)
      page.all('.items').count
    RUBY
  end

  it 'does not register an offense for find without wait option' do
    expect_no_offenses(<<~RUBY)
      page.find('.button')
    RUBY
  end

  it 'does not register an offense for positive wait time' do
    expect_no_offenses(<<~RUBY)
      page.first('.navigation-menu', wait: 5).click
    RUBY
  end

  it 'does not register an offense for wait with variable' do
    expect_no_offenses(<<~RUBY)
      timeout = 10
      page.first('.menu', wait: timeout)
    RUBY
  end

  it 'does not register an offense for other methods' do
    expect_no_offenses(<<~RUBY)
      page.click_button('.submit', wait: 0)
    RUBY
  end
end
