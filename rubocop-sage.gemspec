# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'rubocop-sage'
  spec.version = '0.1.0'
  spec.authors = ['Anthony Panozzo']
  spec.summary = 'Custom RuboCop cops for opinionated best practices'
  spec.description = 'RuboCop extension with custom cops for RSpec, Capybara, and Rails. Designed with clear, concise output for LLM agents.'
  spec.homepage = 'https://github.com/panozzaj/rubocop-sage'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata = {
    'default_lint_roller_plugin' => 'RuboCop::Sage::Plugin'
  }

  spec.files = Dir['lib/**/*', 'config/**/*', 'README.md', 'LICENSE.txt']
  spec.require_paths = %w[lib]

  spec.add_dependency 'lint_roller', '~> 1.1'
  spec.add_dependency 'rubocop', '>= 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
