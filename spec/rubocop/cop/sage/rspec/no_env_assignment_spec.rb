# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoEnvAssignment, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for ENV assignment with string key' do
    expect_offense(<<~RUBY, code: "ENV['API_KEY'] = 'test_key'")
      %{code}
      ^{code} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
    RUBY
  end

  it 'registers an offense for ENV assignment with double-quoted string' do
    expect_offense(<<~RUBY, code: 'ENV["RAILS_ENV"] = "test"')
      %{code}
      ^{code} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
    RUBY
  end

  it 'registers an offense for ENV assignment with variable value' do
    expect_offense(<<~RUBY, assignment: "ENV['API_KEY'] = api_key")
      api_key = 'my_key'
      %{assignment}
      ^{assignment} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
    RUBY
  end

  it 'registers an offense for ENV assignment in a method' do
    expect_offense(<<~RUBY, assignment: "ENV['DATABASE_URL'] = 'postgres://localhost'")
      def setup_env
        %{assignment}
        ^{assignment} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
      end
    RUBY
  end

  it 'registers an offense for ENV assignment in a before block' do
    expect_offense(<<~RUBY, assignment: "ENV['FOO'] = 'bar'")
      before do
        %{assignment}
        ^{assignment} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
      end
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

  it 'does not register an offense for ClimateControl in around block' do
    expect_no_offenses(<<~RUBY)
      around do |example|
        ClimateControl.modify(API_KEY: 'test_key') do
          example.run
        end
      end
    RUBY
  end

  it 'does not register an offense for other constant assignment' do
    expect_no_offenses(<<~RUBY)
      CONFIG['key'] = 'value'
    RUBY
  end

  it 'registers an offense for multiple ENV assignments' do
    expect_offense(<<~RUBY, foo: "ENV['FOO'] = 'foo'", bar: "ENV['BAR'] = 'bar'")
      %{foo}
      ^{foo} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
      %{bar}
      ^{bar} Sage/RSpec/NoEnvAssignment: Use ClimateControl.modify [...]
    RUBY
  end
end
