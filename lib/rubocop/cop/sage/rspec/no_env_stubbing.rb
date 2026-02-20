# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Don't stub ENV in tests; use ClimateControl instead.
        #
        # Stubbing ENV with `allow(ENV).to receive(...)` bypasses real ENV
        # behavior and can mask bugs. ClimateControl temporarily sets real
        # environment variables with automatic cleanup, giving more realistic
        # test coverage.
        #
        # @example
        #   # bad
        #   allow(ENV).to receive(:fetch).with('API_KEY').and_return('test_key')
        #   allow(ENV).to receive(:[]).with('API_KEY').and_return('test_key')
        #   allow(ENV).to receive(:fetch).and_call_original
        #
        #   # good
        #   ClimateControl.modify(API_KEY: 'test_key') do
        #     # test code
        #   end
        #
        class NoEnvStubbing < Base
          MSG = 'Use ClimateControl.modify instead of stubbing ENV in tests.'

          # @!method allow_env_to?(node)
          def_node_matcher :allow_env_to?, <<~PATTERN
            (send (send nil? :allow (const nil? :ENV)) :to ...)
          PATTERN

          # allow(ENV).to is always a regular send, never safe navigation
          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            return unless allow_env_to?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
