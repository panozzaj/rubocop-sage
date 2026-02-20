# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoConditionals, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  it 'registers an offense for if statement in it block' do
    expect_offense(<<~RUBY, code: 'if user.premium?')
      it 'processes the order' do
        %{code}
        ^{code} Avoid conditionals [...]
          expect(order.discount).to eq(20)
        else
          expect(order.discount).to eq(0)
        end
      end
    RUBY
  end

  it 'registers an offense for unless statement in it block' do
    expect_offense(<<~RUBY, code: 'unless user.premium?')
      it 'processes the order' do
        %{code}
        ^{code} Avoid conditionals [...]
          expect(order.discount).to eq(0)
        end
      end
    RUBY
  end

  it 'registers an offense for modifier if' do
    expect_offense(<<~RUBY, code: "button.click if page.has_css?('.submit')")
      it 'clicks button' do
        %{code}
        ^{code} Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for modifier unless' do
    expect_offense(<<~RUBY, code: 'process_data unless data.empty?')
      it 'processes data' do
        %{code}
        ^{code} Avoid conditionals [...]
      end
    RUBY
  end

  it 'registers an offense for case statement' do
    expect_offense(<<~RUBY, code: 'case user.type')
      it 'handles different types' do
        %{code}
        ^{code} Avoid conditionals [...]
        when 'admin'
          expect(user.permissions).to include(:delete)
        when 'user'
          expect(user.permissions).to include(:read)
        end
      end
    RUBY
  end

  it 'registers an offense for ternary operator' do
    expect_offense(<<~RUBY, ternary: 'user.premium? ? 20 : 0')
      it 'calculates discount' do
        discount = %{ternary}
                   ^{ternary} Avoid conditionals [...]
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
    expect_offense(<<~RUBY, code: 'if condition')
      specify do
        %{code}
        ^{code} Avoid conditionals [...]
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'works with example' do
    expect_offense(<<~RUBY, code: 'if condition')
      example do
        %{code}
        ^{code} Avoid conditionals [...]
          expect(true).to be true
        end
      end
    RUBY
  end
end
