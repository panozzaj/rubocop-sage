# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoRescue, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  it 'registers an offense for begin/rescue in it block' do
    expect_offense(<<~RUBY, code: 'rescue StandardError')
      it 'processes data' do
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
      it 'saves record' do
        record.save %{rescue_clause}
                    ^{rescue_clause} Avoid rescue [...]
      end
    RUBY
  end

  it 'registers an offense for rescue with specific error class' do
    expect_offense(<<~RUBY, code: 'rescue ArgumentError => e')
      it 'handles errors' do
        begin
          dangerous_operation
        %{code}
        ^{code} Avoid rescue [...]
          logger.error(e)
        end
      end
    RUBY
  end

  it 'registers an offense for rescue with multiple error classes' do
    expect_offense(<<~RUBY, code: 'rescue ArgumentError, TypeError')
      it 'handles errors' do
        begin
          operation
        %{code}
        ^{code} Avoid rescue [...]
          # handle
        end
      end
    RUBY
  end

  it 'registers an offense for rescue with ensure' do
    expect_offense(<<~RUBY, code: 'rescue StandardError')
      it 'cleans up' do
        begin
          operation
        %{code}
        ^{code} Avoid rescue [...]
          # handle
        ensure
          cleanup
        end
      end
    RUBY
  end

  it 'does not register an offense outside test examples' do
    expect_no_offenses(<<~RUBY)
      RSpec.describe User do
        def helper
          operation rescue nil
        end

        it 'works' do
          expect(helper).to be_nil
        end
      end
    RUBY
  end

  it 'does not register an offense for rescue in helper methods' do
    expect_no_offenses(<<~RUBY)
      it 'processes data' do
        def process_safely
          begin
            process_data
          rescue StandardError
            nil
          end
        end

        expect(process_safely).to be_nil
      end
    RUBY
  end

  it 'does not register an offense in context blocks' do
    expect_no_offenses(<<~RUBY)
      context 'with errors' do
        it 'raises error' do
          expect { operation }.to raise_error(StandardError)
        end
      end
    RUBY
  end

  it 'works with specify' do
    expect_offense(<<~RUBY, rescue_clause: 'rescue nil')
      specify do
        operation %{rescue_clause}
                  ^{rescue_clause} Avoid rescue [...]
      end
    RUBY
  end

  it 'works with example' do
    expect_offense(<<~RUBY, code: 'rescue')
      example do
        begin
          operation
        %{code}
        ^{code} Avoid rescue [...]
          nil
        end
      end
    RUBY
  end

  it 'works with scenario' do
    expect_offense(<<~RUBY, rescue_clause: 'rescue redirect_to_home')
      scenario 'user logs in' do
        login %{rescue_clause}
              ^{rescue_clause} Avoid rescue [...]
      end
    RUBY
  end
end
