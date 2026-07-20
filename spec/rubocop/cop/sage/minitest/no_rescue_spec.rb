# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Minitest::NoRescue, :config do
  let(:gem_versions) { { 'minitest' => '5.0' } }

  it 'registers an offense for begin/rescue in test method' do
    expect_offense(<<~RUBY, code: 'rescue StandardError')
      def test_processes_data
        begin
          process_data(input)
        %{code}
        ^{code} Avoid rescue [...]
          # handle error
        end
      end
    RUBY
  end

  it 'registers an offense for rescue modifier' do
    expect_offense(<<~RUBY, rescue_clause: 'rescue nil')
      def test_saves_record
        record.save %{rescue_clause}
                    ^{rescue_clause} Avoid rescue [...]
      end
    RUBY
  end

  it 'registers an offense for rescue with specific error class' do
    expect_offense(<<~RUBY, code: 'rescue ArgumentError => e')
      def test_handles_errors
        begin
          dangerous_operation
        %{code}
        ^{code} Avoid rescue [...]
          logger.error(e)
        end
      end
    RUBY
  end

  it 'registers an offense in Rails test block' do
    expect_offense(<<~RUBY, code: 'rescue StandardError')
      test 'processes data' do
        begin
          process_data(input)
        %{code}
        ^{code} Avoid rescue [...]
          # handle
        end
      end
    RUBY
  end

  it 'does not register an offense in non-test methods' do
    expect_no_offenses(<<~RUBY)
      def helper
        operation rescue nil
      end
    RUBY
  end

  it 'does not register an offense in setup' do
    expect_no_offenses(<<~RUBY)
      def setup
        operation rescue nil
      end
    RUBY
  end

  it 'does not register an offense for rescue in nested method definitions' do
    expect_no_offenses(<<~RUBY)
      def test_something
        def process_safely
          begin
            process_data
          rescue StandardError
            nil
          end
        end

        assert_nil process_safely
      end
    RUBY
  end
end
