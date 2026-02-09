# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Don't stub `Rails.env` in tests; use configuration instead.
        #
        # Stubbing `Rails.env` predicates creates inconsistent state: e.g.,
        # `Rails.env.production?` returns `true` while `Rails.env` still
        # equals `"test"`. Stubbing `Rails.env` itself is also fragile
        # since the actual Rails configuration, database, cache stores, etc.
        # remain those of the test environment.
        #
        # Instead, extract environment-dependent behavior behind
        # configuration that can be set directly in tests.
        #
        # @example
        #   # bad
        #   allow(Rails.env).to receive(:production?).and_return(true)
        #   allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
        #
        #   # good - extract to configuration
        #   allow(MyApp.config).to receive(:use_real_service?).and_return(true)
        #
        class NoRailsEnvStubbing < Base
          MSG = 'Don\'t stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.'

          # Matches: allow(Rails.env).to receive(...)
          # @!method allow_rails_env_to?(node)
          def_node_matcher :allow_rails_env_to?, <<~PATTERN
            (send
              (send nil? :allow (send (const nil? :Rails) :env))
              :to ...)
          PATTERN

          # Matches: allow(Rails).to receive(:env)...
          # @!method allow_rails_to_receive_env?(node)
          def_node_matcher :allow_rails_to_receive_env?, <<~PATTERN
            (send
              (send nil? :allow (const nil? :Rails))
              :to
              {
                (send nil? :receive (sym :env))
                (send (send nil? :receive (sym :env)) ...)
              }
              ...)
          PATTERN

          def on_send(node)
            return unless allow_rails_env_to?(node) || allow_rails_to_receive_env?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
