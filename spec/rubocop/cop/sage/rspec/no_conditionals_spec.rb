# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoConditionals, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for if statement in it block' do
    expect_offense(<<~RUBY)
      it 'processes the order' do
        if user.premium?
        ^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
          expect(order.discount).to eq(20)
        else
          expect(order.discount).to eq(0)
        end
      end
    RUBY
  end

  it 'registers an offense for unless statement in it block' do
    expect_offense(<<~RUBY)
      it 'processes the order' do
        unless user.premium?
        ^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
          expect(order.discount).to eq(0)
        end
      end
    RUBY
  end

  it 'registers an offense for modifier if' do
    expect_offense(<<~RUBY)
      it 'clicks button' do
        button.click if page.has_css?('.submit')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for modifier unless' do
    expect_offense(<<~RUBY)
      it 'processes data' do
        process_data unless data.empty?
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for case statement' do
    expect_offense(<<~RUBY)
      it 'handles different types' do
        case user.type
        ^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
        when 'admin'
          expect(user.permissions).to include(:delete)
        when 'user'
          expect(user.permissions).to include(:read)
        end
      end
    RUBY
  end

  it 'registers an offense for ternary operator' do
    expect_offense(<<~RUBY)
      it 'calculates discount' do
        discount = user.premium? ? 20 : 0
                   ^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
        expect(discount).to be_positive
      end
    RUBY
  end

  it 'does not register an offense in context blocks' do
    expect_no_offenses(<<~RUBY)
      context 'when user is premium' do
        it 'applies discount' do
          expect(order.discount).to eq(20)
        end
      end
    RUBY
  end

  it 'does not register an offense in describe blocks' do
    expect_no_offenses(<<~RUBY)
      describe 'premium users' do
        it 'applies discount' do
          expect(order.discount).to eq(20)
        end
      end
    RUBY
  end

  it 'does not register an offense for conditionals outside test examples' do
    expect_no_offenses(<<~RUBY)
      RSpec.describe User do
        let(:user) { create(:user, premium: true) if condition }

        it 'has permissions' do
          expect(user.permissions).to be_present
        end
      end
    RUBY
  end

  it 'does not register an offense for conditionals in helper methods' do
    expect_no_offenses(<<~RUBY)
      it 'processes data' do
        def helper_method
          if condition
            'yes'
          else
            'no'
          end
        end

        expect(helper_method).to eq('yes')
      end
    RUBY
  end

  it 'works with specify' do
    expect_offense(<<~RUBY)
      specify do
        if condition
        ^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'works with example' do
    expect_offense(<<~RUBY)
      example do
        if condition
        ^^^^^^^^^^^^ Sage/RSpec/NoConditionals: Avoid conditionals [...]
          expect(true).to be true
        end
      end
    RUBY
  end
end
