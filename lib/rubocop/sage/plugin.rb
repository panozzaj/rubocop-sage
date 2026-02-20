# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module Sage
    # A plugin that integrates RuboCop Sage with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-sage',
          version: VERSION,
          homepage: 'https://github.com/panozzaj/rubocop-sage',
          description: 'Custom RuboCop cops for opinionated best practices.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join('../../..')

        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: project_root.join('config', 'default.yml')
        )
      end
    end
  end
end
