# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Capybara::PreferNoMethods, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for negated has_xpath?' do
    expect_offense(<<~RUBY, code: "!page.has_xpath?('a')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_xpath?` instead of `!has_xpath?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_xpath?('a')
    RUBY
  end

  it 'registers an offense for negated has_css?' do
    expect_offense(<<~RUBY, code: "!page.has_css?('.flash')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_css?` instead of `!has_css?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_css?('.flash')
    RUBY
  end

  it 'registers an offense for negated has_selector?' do
    expect_offense(<<~RUBY, code: "!page.has_selector?('.modal')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_selector?` instead of `!has_selector?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_selector?('.modal')
    RUBY
  end

  it 'registers an offense for negated has_content?' do
    expect_offense(<<~RUBY, code: "!page.has_content?('Error')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_content?` instead of `!has_content?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_content?('Error')
    RUBY
  end

  it 'registers an offense for negated has_link?' do
    expect_offense(<<~RUBY, code: "!page.has_link?('Click me')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_link?` instead of `!has_link?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_link?('Click me')
    RUBY
  end

  it 'registers an offense for negated has_button?' do
    expect_offense(<<~RUBY, code: "!page.has_button?('Submit')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_button?` instead of `!has_button?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_button?('Submit')
    RUBY
  end

  it 'registers an offense for negated has_field?' do
    expect_offense(<<~RUBY, code: "!page.has_field?('Name')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_field?` instead of `!has_field?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_field?('Name')
    RUBY
  end

  it 'registers an offense for negated has_xpath? with multiple arguments' do
    expect_offense(<<~RUBY, code: "!page.has_xpath?('//div', text: 'Hello')")
      %{code}
      ^{code} Sage/Capybara/PreferNoMethods: Use `has_no_xpath?` instead of `!has_xpath?` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_xpath?('//div', text: 'Hello')
    RUBY
  end

  it 'does not register an offense for has_no_xpath?' do
    expect_no_offenses(<<~RUBY)
      page.has_no_xpath?('a')
    RUBY
  end

  it 'does not register an offense for has_xpath?' do
    expect_no_offenses(<<~RUBY)
      page.has_xpath?('a')
    RUBY
  end

  it 'does not register an offense for negated non-Capybara methods' do
    expect_no_offenses(<<~RUBY)
      !object.has_something?
    RUBY
  end

  it 'does not register an offense for complex expressions' do
    expect_no_offenses(<<~RUBY)
      !within('.modal') { page.has_css?('.button') }
    RUBY
  end
end
