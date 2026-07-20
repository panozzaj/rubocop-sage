# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Minitest
        # Avoid `assert_nothing_raised` in tests.
        #
        # This assertion checks that code "doesn't crash" rather than verifying
        # what it should actually do. It produces tests that pass for the wrong
        # reasons and provide no meaningful coverage of behavior.
        #
        # This is especially common when LLM coding agents write a "red" test as
        # "doesn't crash" — it fails because the code crashes, gets fixed, then
        # passes because it no longer crashes. But the test never verifies the
        # actual behavior.
        #
        # @example
        #   # bad
        #   def test_processes_data
        #     assert_nothing_raised { process_data(input) }
        #   end
        #
        #   # bad
        #   def test_processes_data
        #     assert_nothing_raised(StandardError) { process_data(input) }
        #   end
        #
        #   # good - assert the actual behavior
        #   def test_processes_data
        #     assert_equal expected_result, process_data(input)
        #   end
        #
        #   # good - assert a side effect
        #   def test_creates_record
        #     assert_difference('Record.count', 1) { process_data(input) }
        #   end
        #
        class AvoidAssertNothingRaised < Base
          requires_gem 'minitest'

          MSG = 'Avoid `assert_nothing_raised`. ' \
                'Assert what the code *should do*, not that it doesn\'t crash.'

          RESTRICT_ON_SEND = %i[assert_nothing_raised].freeze

          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            add_offense(node)
          end
        end
      end
    end
  end
end
