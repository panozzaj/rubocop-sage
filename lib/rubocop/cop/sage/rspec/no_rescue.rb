# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Avoid rescue blocks in test examples.
        #
        # Using rescue in tests hides failures and makes tests pass when they should fail.
        # Tests should fail loudly when something goes wrong. If you need to test error
        # handling, use `expect { }.to raise_error(...)` instead.
        #
        # The only acceptable use is when documenting/exploring current error behavior,
        # which should be clearly marked with pending/skip.
        #
        # @example
        #   # bad
        #   it 'processes the data' do
        #     begin
        #       process_data(invalid_input)
        #     rescue StandardError
        #       # silently ignore errors
        #     end
        #   end
        #
        #   # bad
        #   it 'saves the record' do
        #     record.save rescue nil
        #   end
        #
        #   # good
        #   it 'raises an error for invalid input' do
        #     expect { process_data(invalid_input) }.to raise_error(ValidationError)
        #   end
        #
        #   # good
        #   it 'saves the record' do
        #     expect(record.save).to be true
        #   end
        #
        class NoRescue < Base
          MSG = 'Avoid rescue in tests. Tests should fail loudly. Use `expect { }.to raise_error(...)` to test error handling.'

          # RSpec example blocks (it/specify/example) don't use numbered block params
          def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
            return unless example_block?(node)

            find_rescues(node).each do |rescue_node|
              add_offense(rescue_node)
            end
          end

          private

          def example_block?(node)
            return false unless node.block_type?

            method_name = node.method_name
            %i[it specify example scenario].include?(method_name)
          end

          def find_rescues(node)
            rescues = []

            node.each_descendant(:rescue) do |descendant|
              # Don't flag rescues inside helper methods defined in the test
              next if inside_method_definition?(descendant, node)

              # For rescue modifier (e.g., `foo rescue nil`), there are no resbody children
              # For begin/rescue blocks, skip the rescue node and report on resbody instead
              if descendant.resbody_branches.empty?
                # Rescue modifier - report on the rescue node
                rescues << descendant
              else
                # Begin/rescue block - report on each resbody (rescue keyword line)
                descendant.resbody_branches.each do |resbody|
                  rescues << resbody
                end
              end
            end

            rescues
          end

          def inside_method_definition?(rescue_node, example_node)
            rescue_node.each_ancestor(:any_def) do |ancestor|
              return true if ancestor != example_node
            end

            false
          end
        end
      end
    end
  end
end
