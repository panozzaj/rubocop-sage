# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Avoid `expect { ... }.not_to raise_error` and similar weak assertions.
        #
        # This pattern asserts that code "doesn't crash" rather than asserting
        # what it should actually do. It produces tests that pass for the wrong
        # reasons and provide no meaningful coverage of behavior.
        #
        # This is especially common when LLM coding agents write a "red" test as
        # "doesn't crash" — it fails because the code crashes, gets fixed, then
        # passes because it no longer crashes. But the test doesn't verify the
        # actual behavior.
        #
        # @example
        #   # bad
        #   it 'processes the data' do
        #     expect { process_data(input) }.not_to raise_error
        #   end
        #
        #   # bad
        #   it 'processes the data' do
        #     expect { process_data(input) }.to_not raise_error
        #   end
        #
        #   # bad
        #   it 'processes the data' do
        #     expect { process_data(input) }.to_not raise_exception
        #   end
        #
        #   # good - assert the actual behavior
        #   it 'processes the data' do
        #     expect(process_data(input)).to eq(expected_result)
        #   end
        #
        #   # good - assert a side effect
        #   it 'creates a record' do
        #     expect { process_data(input) }.to change(Record, :count).by(1)
        #   end
        #
        class AvoidNotToRaiseError < Base
          requires_gem 'rspec-core'

          MSG = 'Avoid `expect { ... }.not_to raise_error`. ' \
                'Assert what the code *should do*, not that it doesn\'t crash.'

          RESTRICT_ON_SEND = %i[not_to to_not].freeze

          # @!method not_to_raise_error?(node)
          def_node_matcher :not_to_raise_error?, <<~PATTERN
            (send
              (block (send nil? :expect) ...)
              {:not_to :to_not}
              (send nil? {:raise_error :raise_exception} ...))
          PATTERN

          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            return unless not_to_raise_error?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
