# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoEnvStubbing, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense for allow(ENV).to receive(:fetch) with args' do
    expect_offense(<<~RUBY)
      allow(ENV).to receive(:fetch).with("APP_NAME").and_return("my_app")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoEnvStubbing: Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:fetch).and_call_original' do
    expect_offense(<<~RUBY)
      allow(ENV).to receive(:fetch).and_call_original
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoEnvStubbing: Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:[])' do
    expect_offense(<<~RUBY)
      allow(ENV).to receive(:[]).with("APP_NAME").and_return("my_app")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoEnvStubbing: Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:fetch) with multiple args' do
    expect_offense(<<~RUBY)
      allow(ENV).to receive(:fetch).with("FEATURE_FLAG", anything).and_return(false)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoEnvStubbing: Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for bare allow(ENV).to receive(:fetch)' do
    expect_offense(<<~RUBY)
      allow(ENV).to receive(:fetch)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sage/RSpec/NoEnvStubbing: Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'does not register an offense for allow on other objects' do
    expect_no_offenses(<<~RUBY)
      allow(service).to receive(:fetch).and_return("result")
    RUBY
  end

  it 'does not register an offense for ClimateControl.modify' do
    expect_no_offenses(<<~RUBY)
      ClimateControl.modify(APP_NAME: "my_app") do
        # test code
      end
    RUBY
  end

  it 'does not register an offense for reading ENV' do
    expect_no_offenses(<<~RUBY)
      ENV.fetch("APP_NAME")
    RUBY
  end
end
