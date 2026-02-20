# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Don't assign to ENV directly in tests; use ClimateControl instead.
        #
        # Direct ENV assignment modifies global state, which can affect other tests
        # when you don't restore the original value. This is especially problematic
        # when running tests in parallel threads, leading to flaky, hard-to-debug failures.
        #
        # The ClimateControl gem provides a safe way to temporarily modify environment
        # variables with automatic cleanup.
        #
        # @example
        #   # bad
        #   ENV['API_KEY'] = 'test_key'
        #   ENV['RAILS_ENV'] = 'test'
        #
        #   # good
        #   ClimateControl.modify(API_KEY: 'test_key') do
        #     # test code
        #   end
        #
        #   # also good
        #   around do |example|
        #     ClimateControl.modify(API_KEY: 'test_key') do
        #       example.run
        #     end
        #   end
        #
        class NoEnvAssignment < Base
          requires_gem 'rspec-core'
          MSG = 'Use ClimateControl.modify to change ENV in tests instead of direct assignment.'

          # @!method env_assignment?(node)
          def_node_matcher :env_assignment?, <<~PATTERN
            (send (const nil? :ENV) :[]= ...)
          PATTERN

          # ENV[]= is always a regular send, never safe navigation
          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            return unless env_assignment?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
