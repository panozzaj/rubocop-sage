# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Minitest::AvoidAssertNothingRaised, :config do
  let(:gem_versions) { { 'minitest' => '5.0' } }

  it 'registers an offense for assert_nothing_raised with a block' do
    expect_offense(<<~RUBY)
      def test_processes_data
        assert_nothing_raised { process_data(input) }
        ^^^^^^^^^^^^^^^^^^^^^ Avoid `assert_nothing_raised`. [...]
      end
    RUBY
  end

  it 'registers an offense for assert_nothing_raised with a do block' do
    expect_offense(<<~RUBY)
      def test_processes_data
        assert_nothing_raised do
        ^^^^^^^^^^^^^^^^^^^^^ Avoid `assert_nothing_raised`. [...]
          process_data(input)
        end
      end
    RUBY
  end

  it 'registers an offense for assert_nothing_raised with an exception class' do
    expect_offense(<<~RUBY)
      def test_processes_data
        assert_nothing_raised(StandardError) { process_data(input) }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `assert_nothing_raised`. [...]
      end
    RUBY
  end

  it 'registers an offense for assert_nothing_raised with a message' do
    expect_offense(<<~RUBY)
      def test_something
        assert_nothing_raised('should not raise') { something }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `assert_nothing_raised`. [...]
      end
    RUBY
  end

  it 'registers an offense outside of test methods' do
    expect_offense(<<~RUBY)
      assert_nothing_raised { something }
      ^^^^^^^^^^^^^^^^^^^^^ Avoid `assert_nothing_raised`. [...]
    RUBY
  end

  it 'does not register an offense for assert_raises' do
    expect_no_offenses(<<~RUBY)
      def test_raises_on_invalid_input
        assert_raises(ArgumentError) { process_data(nil) }
      end
    RUBY
  end

  it 'does not register an offense for other assertions' do
    expect_no_offenses(<<~RUBY)
      def test_processes_data
        assert_equal expected_result, process_data(input)
      end
    RUBY
  end
end
