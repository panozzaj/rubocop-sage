# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Minitest::NoConditionals, :config do
  let(:gem_versions) { { 'minitest' => '5.0' } }

  it 'registers an offense for if statement in test method' do
    expect_offense(<<~RUBY, code: 'if user.premium?')
      def test_processes_order
        %{code}
        ^{code} Avoid conditionals [...]
          assert_equal 20, order.discount
        else
          assert_equal 0, order.discount
        end
      end
    RUBY
  end

  it 'registers an offense for unless statement in test method' do
    expect_offense(<<~RUBY, code: 'unless user.premium?')
      def test_processes_order
        %{code}
        ^{code} Avoid conditionals [...]
          assert_equal 0, order.discount
        end
      end
    RUBY
  end

  it 'registers an offense for modifier if' do
    expect_offense(<<~RUBY, code: 'button.click if page.has_css?(".submit")')
      def test_clicks_button
        %{code}
        ^{code} Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for modifier unless' do
    expect_offense(<<~RUBY, code: 'process_data unless data.empty?')
      def test_processes_data
        %{code}
        ^{code} Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for case statement' do
    expect_offense(<<~RUBY, code: 'case user.type')
      def test_handles_types
        %{code}
        ^{code} Avoid conditionals [...]
        when 'admin'
          assert_includes user.permissions, :delete
        when 'user'
          assert_includes user.permissions, :read
        end
      end
    RUBY
  end

  it 'registers an offense for ternary operator' do
    expect_offense(<<~RUBY, ternary: 'user.premium? ? 20 : 0')
      def test_calculates_discount
        discount = %{ternary}
                   ^{ternary} Avoid conditionals [...]
        assert_operator discount, :>, 0
      end
    RUBY
  end

  it 'registers an offense in Rails test block' do
    expect_offense(<<~RUBY, code: 'if condition')
      test 'processes order' do
        %{code}
        ^{code} Avoid conditionals [...]
          assert true
        end
      end
    RUBY
  end

  it 'does not register an offense in non-test methods' do
    expect_no_offenses(<<~RUBY)
      def setup
        @user = if admin?
                  create_admin
                else
                  create_user
                end
      end
    RUBY
  end

  it 'does not register an offense in helper methods' do
    expect_no_offenses(<<~RUBY)
      def helper_method
        if condition
          'yes'
        else
          'no'
        end
      end
    RUBY
  end

  it 'does not register an offense for conditionals in nested method definitions' do
    expect_no_offenses(<<~RUBY)
      def test_something
        def helper
          if condition
            'yes'
          else
            'no'
          end
        end

        assert_equal 'yes', helper
      end
    RUBY
  end
end
