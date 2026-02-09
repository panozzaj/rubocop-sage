# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoRailsEnvStubbing, :config do
  let(:config) { RuboCop::Config.new }

  context 'when stubbing predicates on Rails.env' do
    it 'registers an offense for allow(Rails.env).to receive(:production?)' do
      expect_offense(<<~RUBY)
        allow(Rails.env).to receive(:production?).and_return(true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoRailsEnvStubbing: Don't stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.
      RUBY
    end

    it 'registers an offense for allow(Rails.env).to receive(:test?)' do
      expect_offense(<<~RUBY)
        allow(Rails.env).to receive(:test?).and_return(false)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoRailsEnvStubbing: Don't stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.
      RUBY
    end

    it 'registers an offense for allow(Rails.env).to receive(:development?)' do
      expect_offense(<<~RUBY)
        allow(Rails.env).to receive(:development?).and_return(true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoRailsEnvStubbing: Don't stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.
      RUBY
    end
  end

  context 'when stubbing Rails.env itself' do
    it 'registers an offense for allow(Rails).to receive(:env).and_return(...)' do
      expect_offense(<<~RUBY)
        allow(Rails).to receive(:env).and_return("production".inquiry)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoRailsEnvStubbing: Don't stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.
      RUBY
    end

    it 'registers an offense for bare allow(Rails).to receive(:env)' do
      expect_offense(<<~RUBY)
        allow(Rails).to receive(:env)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoRailsEnvStubbing: Don't stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.
      RUBY
    end
  end

  context 'when not stubbing Rails.env' do
    it 'does not register an offense for allow on other Rails methods' do
      expect_no_offenses(<<~RUBY)
        allow(Rails).to receive(:logger).and_return(logger)
      RUBY
    end

    it 'does not register an offense for allow on non-Rails objects' do
      expect_no_offenses(<<~RUBY)
        allow(service).to receive(:production?).and_return(true)
      RUBY
    end

    it 'does not register an offense for reading Rails.env' do
      expect_no_offenses(<<~RUBY)
        Rails.env.production?
      RUBY
    end

    it 'does not register an offense for using Rails.env in expectations' do
      expect_no_offenses(<<~RUBY)
        expect(Rails.env).to eq("test")
      RUBY
    end
  end
end
