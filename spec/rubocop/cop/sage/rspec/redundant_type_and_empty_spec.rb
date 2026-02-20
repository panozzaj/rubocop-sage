# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::RedundantTypeAndEmpty, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  context 'with Array type checks' do
    it 'registers an offense for be_an(Array) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_an(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'registers an offense for be_a(Array) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_a(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'registers an offense for be_kind_of(Array) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_kind_of(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'registers an offense for be_instance_of(Array) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_instance_of(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'registers an offense when be_empty comes first' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_empty')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(json["items"]).to be_an(Array)
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'handles complex subject expressions' do
      expect_offense(<<~RUBY, code: 'expect(response.body["data"]["items"]).to be_an(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          expect(response.body["data"]["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(response.body["data"]["items"]).to eq([])
        end
      RUBY
    end
  end

  context 'with Hash type checks' do
    it 'registers an offense for be_a(Hash) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["data"]).to be_a(Hash)')
        it 'checks data' do
          %{code}
          ^{code} Use eq({}) instead of separate type and emptiness checks.
          expect(json["data"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks data' do
          expect(json["data"]).to eq({})
        end
      RUBY
    end

    it 'registers an offense for be_an(Hash) followed by be_empty' do
      expect_offense(<<~RUBY, code: 'expect(json["data"]).to be_an(Hash)')
        it 'checks data' do
          %{code}
          ^{code} Use eq({}) instead of separate type and emptiness checks.
          expect(json["data"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks data' do
          expect(json["data"]).to eq({})
        end
      RUBY
    end

    it 'registers an offense when be_empty comes first' do
      expect_offense(<<~RUBY, code: 'expect(json["data"]).to be_empty')
        it 'checks data' do
          %{code}
          ^{code} Use eq({}) instead of separate type and emptiness checks.
          expect(json["data"]).to be_a(Hash)
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks data' do
          expect(json["data"]).to eq({})
        end
      RUBY
    end
  end

  context 'when expectations are not redundant' do
    it 'does not register an offense for type check alone' do
      expect_no_offenses(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to be_an(Array)
        end
      RUBY
    end

    it 'does not register an offense for empty check alone' do
      expect_no_offenses(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to be_empty
        end
      RUBY
    end

    it 'does not register an offense for different subjects' do
      expect_no_offenses(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to be_an(Array)
          expect(json["data"]).to be_empty
        end
      RUBY
    end

    it 'does not register an offense when expectations are not consecutive' do
      expect_no_offenses(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to be_an(Array)
          expect(json["total"]).to eq(0)
          expect(json["items"]).to be_empty
        end
      RUBY
    end

    it 'does not register an offense for type check with non-empty assertion' do
      expect_no_offenses(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to be_an(Array)
          expect(json["items"]).not_to be_empty
        end
      RUBY
    end

    it 'does not register an offense for non-Array/Hash types' do
      expect_no_offenses(<<~RUBY)
        it 'checks value' do
          expect(value).to be_a(String)
          expect(value).to be_empty
        end
      RUBY
    end
  end

  context 'with whitespace between expectations' do
    it 'registers an offense when separated by blank lines' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_an(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.

          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end

    it 'registers an offense when separated by comments' do
      expect_offense(<<~RUBY, code: 'expect(json["items"]).to be_an(Array)')
        it 'checks items' do
          %{code}
          ^{code} Use eq([]) instead of separate type and emptiness checks.
          # Check that it's empty
          expect(json["items"]).to be_empty
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'checks items' do
          expect(json["items"]).to eq([])
        end
      RUBY
    end
  end
end
