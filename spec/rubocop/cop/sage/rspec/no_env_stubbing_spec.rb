# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::NoEnvStubbing, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  it 'registers an offense for allow(ENV).to receive(:fetch) with args' do
    expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:fetch).with("APP_NAME").and_return("my_app")')
      %{code}
      ^{code} Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:fetch).and_call_original' do
    expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:fetch).and_call_original')
      %{code}
      ^{code} Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:[])' do
    expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:[]).with("APP_NAME").and_return("my_app")')
      %{code}
      ^{code} Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for allow(ENV).to receive(:fetch) with multiple args' do
    expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:fetch).with("FEATURE_FLAG", anything).and_return(false)')
      %{code}
      ^{code} Use ClimateControl.modify instead of stubbing ENV in tests.
    RUBY
  end

  it 'registers an offense for bare allow(ENV).to receive(:fetch)' do
    expect_offense(<<~RUBY, code: 'allow(ENV).to receive(:fetch)')
      %{code}
      ^{code} Use ClimateControl.modify instead of stubbing ENV in tests.
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
