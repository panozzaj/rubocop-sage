# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Minitest::NoEnvAssignment, :config do
  let(:gem_versions) { { 'minitest' => '5.0' } }

  it 'registers an offense for ENV assignment with string key' do
    expect_offense(<<~RUBY, code: "ENV['API_KEY'] = 'test_key'")
      %{code}
      ^{code} Use ClimateControl.modify [...]
    RUBY
  end

  it 'registers an offense for ENV assignment with double-quoted string' do
    expect_offense(<<~RUBY, code: 'ENV["RAILS_ENV"] = "test"')
      %{code}
      ^{code} Use ClimateControl.modify [...]
    RUBY
  end

  it 'registers an offense for ENV assignment in a setup method' do
    expect_offense(<<~RUBY, assignment: "ENV['DATABASE_URL'] = 'postgres://localhost'")
      def setup
        %{assignment}
        ^{assignment} Use ClimateControl.modify [...]
      end
    RUBY
  end

  it 'registers an offense for ENV assignment in a test method' do
    expect_offense(<<~RUBY, assignment: "ENV['FOO'] = 'bar'")
      def test_something
        %{assignment}
        ^{assignment} Use ClimateControl.modify [...]
      end
    RUBY
  end

  it 'registers an offense for multiple ENV assignments' do
    expect_offense(<<~RUBY, foo: "ENV['FOO'] = 'foo'", bar: "ENV['BAR'] = 'bar'")
      %{foo}
      ^{foo} Use ClimateControl.modify [...]
      %{bar}
      ^{bar} Use ClimateControl.modify [...]
    RUBY
  end

  it 'does not register an offense for ENV reading' do
    expect_no_offenses(<<~RUBY)
      api_key = ENV['API_KEY']
    RUBY
  end

  it 'does not register an offense for ENV.fetch' do
    expect_no_offenses(<<~RUBY)
      api_key = ENV.fetch('API_KEY')
    RUBY
  end

  it 'does not register an offense for ClimateControl.modify' do
    expect_no_offenses(<<~RUBY)
      ClimateControl.modify(API_KEY: 'test_key') do
        # test code
      end
    RUBY
  end

  it 'does not register an offense for other constant assignment' do
    expect_no_offenses(<<~RUBY)
      CONFIG['key'] = 'value'
    RUBY
  end
end
