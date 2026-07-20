# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Minitest
        # Avoid conditional statements in test methods.
        #
        # Conditional logic (if/unless/case) in tests obscures intent and indicates
        # non-deterministic behavior. Tests should have predictable, linear execution.
        # If you need conditional behavior, write separate test methods for each case.
        #
        # @example
        #   # bad
        #   def test_processes_order
        #     if user.premium?
        #       assert_equal 20, order.discount
        #     else
        #       assert_equal 0, order.discount
        #     end
        #   end
        #
        #   # good
        #   def test_premium_user_gets_discount
        #     assert_equal 20, order.discount
        #   end
        #
        #   def test_regular_user_gets_no_discount
        #     assert_equal 0, order.discount
        #   end
        #
        class NoConditionals < Base
          requires_gem 'minitest'
          MSG = 'Avoid conditionals in tests. Write separate test methods for each case.'

          def on_def(node)
            return unless test_method?(node)

            find_conditionals(node).each do |conditional|
              add_offense(conditional)
            end
          end

          # Rails `test "name" do ... end` blocks don't use numbered block params
          def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
            return unless rails_test_block?(node)

            find_conditionals(node).each do |conditional|
              add_offense(conditional)
            end
          end

          private

          def test_method?(node)
            node.method_name.to_s.start_with?('test_')
          end

          def rails_test_block?(node)
            node.method_name == :test
          end

          def find_conditionals(node)
            conditionals = []

            node.each_descendant(:if, :case) do |descendant|
              next if inside_method_definition?(descendant, node)

              conditionals << descendant
            end

            conditionals
          end

          def inside_method_definition?(conditional_node, test_node)
            conditional_node.each_ancestor(:any_def) do |ancestor|
              return true if ancestor != test_node
            end

            false
          end
        end
      end
    end
  end
end
