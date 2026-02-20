# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::Rails::AllWithBlock, :config do
  let(:gem_versions) { { 'activerecord' => '7.0' } }

  it 'registers an offense for Model.all with a do block' do
    expect_offense(<<~RUBY)
      User.all do |user|
      ^^^^^^^^ `.all` ignores blocks. Use `.find_each` or `.all.each` instead.
        user.do_something
      end
    RUBY
  end

  it 'registers an offense for Model.all with a brace block' do
    expect_offense(<<~RUBY)
      User.all { |user| user.do_something }
      ^^^^^^^^ `.all` ignores blocks. Use `.find_each` or `.all.each` instead.
    RUBY
  end

  it 'registers an offense for chained scope.all with a block' do
    expect_offense(<<~RUBY)
      User.active.all do |user|
      ^^^^^^^^^^^^^^^ `.all` ignores blocks. Use `.find_each` or `.all.each` instead.
        user.notify
      end
    RUBY
  end

  it 'registers an offense for variable.all with a block' do
    expect_offense(<<~RUBY)
      scope.all do |record|
      ^^^^^^^^^ `.all` ignores blocks. Use `.find_each` or `.all.each` instead.
        record.process
      end
    RUBY
  end

  it 'does not register an offense for .all without a block' do
    expect_no_offenses(<<~RUBY)
      User.all
    RUBY
  end

  it 'does not register an offense for .all.each with a block' do
    expect_no_offenses(<<~RUBY)
      User.all.each do |user|
        user.do_something
      end
    RUBY
  end

  it 'does not register an offense for .find_each with a block' do
    expect_no_offenses(<<~RUBY)
      User.find_each do |user|
        user.do_something
      end
    RUBY
  end

  it 'does not register an offense for .all? with a block' do
    expect_no_offenses(<<~RUBY)
      [1, 2, 3].all? { |x| x > 0 }
    RUBY
  end
end
