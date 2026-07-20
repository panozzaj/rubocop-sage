# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Minitest
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
        #   Rails.stub(:env, 'production'.inquiry) do
        #     # test code
        #   end
        #
        #   # bad (Mocha)
        #   Rails.stubs(:env).returns('production'.inquiry)
        #   Rails.env.stubs(:production?).returns(true)
        #
        #   # good - extract to configuration
        #   MyApp.config.stub(:use_real_service?, true) do
        #     # test code
        #   end
        #
        class NoRailsEnvStubbing < Base
          requires_gem 'minitest'
          MSG = 'Don\'t stub Rails.env in tests. Extract environment-dependent behavior behind configuration instead.'

          # Matches: Rails.stub(:env, ...) — Minitest stub
          # @!method rails_stub_env?(node)
          def_node_matcher :rails_stub_env?, <<~PATTERN
            (send (const nil? :Rails) :stub (sym :env) ...)
          PATTERN

          # Matches: Rails.stubs(:env) — Mocha
          # @!method rails_mocha_stubs_env?(node)
          def_node_matcher :rails_mocha_stubs_env?, <<~PATTERN
            (send (const nil? :Rails) :stubs (sym :env) ...)
          PATTERN

          # Matches: Rails.env.stubs(:production?) — Mocha on env predicates
          # @!method rails_env_mocha_stubs?(node)
          def_node_matcher :rails_env_mocha_stubs?, <<~PATTERN
            (send (send (const nil? :Rails) :env) :stubs ...)
          PATTERN

          # Matches: Rails.env.stub(:production?, ...) — Minitest stub on env predicates
          # @!method rails_env_stub?(node)
          def_node_matcher :rails_env_stub?, <<~PATTERN
            (send (send (const nil? :Rails) :env) :stub ...)
          PATTERN

          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            return unless rails_stub_env?(node) ||
                          rails_mocha_stubs_env?(node) ||
                          rails_env_mocha_stubs?(node) ||
                          rails_env_stub?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
