# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Capybara::AvoidExplicitVisible, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for visible: true with have_selector' do
    expect_offense(<<~RUBY)
      expect(page).to have_selector('.container', visible: true)
                                                  ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      expect(page).to have_selector('.container')
    RUBY
  end

  it 'registers an offense for visible: true with have_no_selector' do
    expect_offense(<<~RUBY)
      expect(page).to have_no_selector('.container', visible: true)
                                                     ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      expect(page).to have_no_selector('.container')
    RUBY
  end

  it 'registers an offense for visible: true with has_css?' do
    expect_offense(<<~RUBY)
      page.has_css?('.container', visible: true)
                                  ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_css?('.container')
    RUBY
  end

  it 'registers an offense for visible: true with has_no_css?' do
    expect_offense(<<~RUBY)
      page.has_no_css?('.container', visible: true)
                                     ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_no_css?('.container')
    RUBY
  end

  it 'registers an offense for visible: true with multiple hash options' do
    expect_offense(<<~RUBY)
      page.has_css?('.container', text: 'Hello', visible: true, count: 2)
                                                 ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_css?('.container', text: 'Hello', count: 2)
    RUBY
  end

  it 'registers an offense for visible: true as first option in hash' do
    expect_offense(<<~RUBY)
      page.has_css?('.container', visible: true, text: 'Hello')
                                  ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_css?('.container', text: 'Hello')
    RUBY
  end

  it 'registers an offense for visible: true as middle option in hash' do
    expect_offense(<<~RUBY)
      page.has_css?('.container', text: 'Hello', visible: true, count: 2)
                                                 ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_css?('.container', text: 'Hello', count: 2)
    RUBY
  end

  it 'does not register an offense for visible: false' do
    expect_no_offenses(<<~RUBY)
      expect(page).to have_selector('.container', visible: false)
    RUBY
  end

  it 'does not register an offense for visible: :all' do
    expect_no_offenses(<<~RUBY)
      expect(page).to have_selector('.container', visible: :all)
    RUBY
  end

  it 'does not register an offense for visible: :hidden' do
    expect_no_offenses(<<~RUBY)
      expect(page).to have_selector('.container', visible: :hidden)
    RUBY
  end

  it 'does not register an offense when visible option is not present' do
    expect_no_offenses(<<~RUBY)
      expect(page).to have_selector('.container')
    RUBY
  end

  it 'does not register an offense for other options without visible' do
    expect_no_offenses(<<~RUBY)
      page.has_css?('.container', text: 'Hello', count: 2)
    RUBY
  end

  it 'works with has_xpath?' do
    expect_offense(<<~RUBY)
      page.has_xpath?('//div', visible: true)
                               ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_xpath?('//div')
    RUBY
  end

  it 'works with has_content?' do
    expect_offense(<<~RUBY)
      page.has_content?('Hello', visible: true)
                                 ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_content?('Hello')
    RUBY
  end

  it 'works with has_link?' do
    expect_offense(<<~RUBY)
      page.has_link?('Click me', visible: true)
                                 ^^^^^^^^^^^^^ Sage/Capybara/AvoidExplicitVisible: Avoid explicit `visible: true` [...]
    RUBY

    expect_correction(<<~RUBY)
      page.has_link?('Click me')
    RUBY
  end
end
