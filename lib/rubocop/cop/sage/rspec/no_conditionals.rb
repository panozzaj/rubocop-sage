# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Avoid conditional statements in test examples.
        #
        # Conditional logic (if/unless/case) in tests obscures intent and indicates
        # non-deterministic behavior. Tests should have predictable, linear execution.
        # If you need conditional behavior, use context blocks to separate test cases.
        #
        # The only acceptable use case is when exploring/documenting current system
        # behavior, which should be clearly marked with pending/skip.
        #
        # @example
        #   # bad
        #   it 'processes the order' do
        #     if user.premium?
        #       expect(order.discount).to eq(20)
        #     else
        #       expect(order.discount).to eq(0)
        #     end
        #   end
        #
        #   # bad
        #   it 'clicks the button if present' do
        #     button.click if page.has_css?('.submit-button')
        #   end
        #
        #   # good
        #   context 'when user is premium' do
        #     it 'applies discount' do
        #       expect(order.discount).to eq(20)
        #     end
        #   end
        #
        #   context 'when user is not premium' do
        #     it 'does not apply discount' do
        #       expect(order.discount).to eq(0)
        #     end
        #   end
        #
        class NoConditionals < Base
          MSG = 'Avoid conditionals in tests. Use context blocks to separate test cases for clarity and determinism.'

          # Find all conditionals within example blocks
          # RSpec example blocks (it/specify/example) don't use numbered block params
          def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
            return unless example_block?(node)

            find_conditionals(node).each do |conditional|
              add_offense(conditional)
            end
          end

          private

          def example_block?(node)
            return false unless node.block_type?

            method_name = node.method_name
            %i[it specify example scenario].include?(method_name)
          end

          def find_conditionals(node)
            conditionals = []

            node.each_descendant(:if, :case) do |descendant|
              # Don't flag conditionals inside helper methods defined in the test
              next if inside_method_definition?(descendant, node)

              conditionals << descendant
            end

            conditionals
          end

          def inside_method_definition?(conditional_node, example_node)
            conditional_node.each_ancestor(:any_def) do |ancestor|
              # If we find a method definition between the conditional and the example block,
              # the conditional is inside a helper method
              return true if ancestor != example_node
            end

            false
          end
        end
      end
    end
  end
end
