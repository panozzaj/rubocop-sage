# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Minitest
        # Avoid rescue blocks in test methods.
        #
        # Using rescue in tests hides failures and makes tests pass when they should fail.
        # Tests should fail loudly when something goes wrong. If you need to test error
        # handling, use `assert_raises(ErrorClass)` instead.
        #
        # @example
        #   # bad
        #   def test_processes_data
        #     begin
        #       process_data(invalid_input)
        #     rescue StandardError
        #       # silently ignore errors
        #     end
        #   end
        #
        #   # bad
        #   def test_saves_record
        #     record.save rescue nil
        #   end
        #
        #   # good
        #   def test_raises_for_invalid_input
        #     assert_raises(ValidationError) { process_data(invalid_input) }
        #   end
        #
        #   # good
        #   def test_saves_record
        #     assert record.save
        #   end
        #
        class NoRescue < Base
          requires_gem 'minitest'
          MSG = 'Avoid rescue in tests. Tests should fail loudly. Use `assert_raises(ErrorClass)` to test error handling.'

          def on_def(node)
            return unless test_method?(node)

            find_rescues(node).each do |rescue_node|
              add_offense(rescue_node)
            end
          end

          # Rails `test "name" do ... end` blocks don't use numbered block params
          def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
            return unless rails_test_block?(node)

            find_rescues(node).each do |rescue_node|
              add_offense(rescue_node)
            end
          end

          private

          def test_method?(node)
            node.method_name.to_s.start_with?('test_')
          end

          def rails_test_block?(node)
            node.method_name == :test
          end

          def find_rescues(node)
            rescues = []

            node.each_descendant(:rescue) do |descendant|
              next if inside_method_definition?(descendant, node)

              if descendant.resbody_branches.empty?
                rescues << descendant
              else
                descendant.resbody_branches.each do |resbody|
                  rescues << resbody
                end
              end
            end

            rescues
          end

          def inside_method_definition?(rescue_node, test_node)
            rescue_node.each_ancestor(:any_def) do |ancestor|
              return true if ancestor != test_node
            end

            false
          end
        end
      end
    end
  end
end
