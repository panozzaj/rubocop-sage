# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::AvoidNotToRaiseError, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  it 'registers an offense for not_to raise_error' do
    expect_offense(<<~RUBY, code: 'expect { process_data(input) }.not_to raise_error')
      it 'processes the data' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense for to_not raise_error' do
    expect_offense(<<~RUBY, code: 'expect { process_data(input) }.to_not raise_error')
      it 'processes the data' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense for not_to raise_exception' do
    expect_offense(<<~RUBY, code: 'expect { something }.not_to raise_exception')
      it 'works' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense for to_not raise_exception' do
    expect_offense(<<~RUBY, code: 'expect { something }.to_not raise_exception')
      it 'works' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense for raise_error with a specific error class' do
    expect_offense(<<~RUBY, code: 'expect { something }.not_to raise_error(ArgumentError)')
      it 'does not raise ArgumentError' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense for raise_error with a message' do
    expect_offense(<<~RUBY, code: "expect { something }.not_to raise_error('bad')")
      it 'does not raise with message' do
        %{code}
        ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
      end
    RUBY
  end

  it 'registers an offense outside of example blocks' do
    expect_offense(<<~RUBY, code: 'expect { something }.not_to raise_error')
      %{code}
      ^{code} Avoid `expect { ... }.not_to raise_error`. [...]
    RUBY
  end

  it 'does not register an offense for positive raise_error' do
    expect_no_offenses(<<~RUBY)
      it 'raises' do
        expect { process_data }.to raise_error(ArgumentError)
      end
    RUBY
  end

  it 'does not register an offense for other negative matchers' do
    expect_no_offenses(<<~RUBY)
      it 'does not change the count' do
        expect { process_data }.not_to change(Record, :count)
      end
    RUBY
  end

  it 'does not register an offense for value expectations' do
    expect_no_offenses(<<~RUBY)
      it 'returns the result' do
        expect(process_data(input)).to eq(expected_result)
      end
    RUBY
  end
end
