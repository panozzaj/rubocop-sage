# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Minitest::NoRailsEnvStubbing, :config do
  let(:gem_versions) { { 'minitest' => '5.0' } }

  context 'with Minitest stub' do
    it 'registers an offense for Rails.stub(:env, ...)' do
      expect_offense(<<~RUBY, code: "Rails.stub(:env, 'production'.inquiry)")
        %{code} do
        ^{code} Don't stub Rails.env in tests. [...]
          # test code
        end
      RUBY
    end

    it 'registers an offense for Rails.env.stub(:production?, ...)' do
      expect_offense(<<~RUBY, code: 'Rails.env.stub(:production?, true)')
        %{code} do
        ^{code} Don't stub Rails.env in tests. [...]
          # test code
        end
      RUBY
    end
  end

  context 'with Mocha stubs' do
    it 'registers an offense for Rails.stubs(:env)' do
      expect_offense(<<~RUBY)
        Rails.stubs(:env).returns('production'.inquiry)
        ^^^^^^^^^^^^^^^^^ Don't stub Rails.env in tests. [...]
      RUBY
    end

    it 'registers an offense for Rails.env.stubs(:production?)' do
      expect_offense(<<~RUBY)
        Rails.env.stubs(:production?).returns(true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't stub Rails.env in tests. [...]
      RUBY
    end
  end

  context 'when not stubbing Rails.env' do
    it 'does not register an offense for stubbing other Rails methods' do
      expect_no_offenses(<<~RUBY)
        Rails.stub(:logger, logger) do
          # test code
        end
      RUBY
    end

    it 'does not register an offense for stubbing non-Rails objects' do
      expect_no_offenses(<<~RUBY)
        service.stub(:env, 'production') do
          # test code
        end
      RUBY
    end

    it 'does not register an offense for reading Rails.env' do
      expect_no_offenses(<<~RUBY)
        Rails.env.production?
      RUBY
    end

    it 'does not register an offense for asserting on Rails.env' do
      expect_no_offenses(<<~RUBY)
        assert_equal 'test', Rails.env
      RUBY
    end
  end
end
