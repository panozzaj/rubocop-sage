# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Use eq([]) or eq({}) instead of separate type and emptiness checks.
        #
        # When checking that a value is an empty array or hash, directly asserting
        # the value with eq([]) or eq({}) is clearer than two separate expectations
        # for type and emptiness.
        #
        # @example
        #   # bad
        #   expect(json["items"]).to be_an(Array)
        #   expect(json["items"]).to be_empty
        #
        #   # bad
        #   expect(data).to be_a(Hash)
        #   expect(data).to be_empty
        #
        #   # bad - works regardless of order
        #   expect(json["items"]).to be_empty
        #   expect(json["items"]).to be_an(Array)
        #
        #   # good
        #   expect(json["items"]).to eq([])
        #
        #   # good
        #   expect(data).to eq({})
        #
        class RedundantTypeAndEmpty < Base
          include RangeHelp
          extend AutoCorrector

          MSG = 'Use eq(%<literal>s) instead of separate type and emptiness checks.'

          # Match: expect(foo).to be_a(Array) / be_an(Array) / be_kind_of(Array) / be_instance_of(Array)
          # @!method type_check?(node)
          def_node_matcher :type_check?, <<~PATTERN
            (send
              (send nil? :expect $_subject)
              {:to :to_not :not_to}
              (send nil? {:be_a :be_an :be_kind_of :be_instance_of}
                (const nil? ${:Array :Hash})))
          PATTERN

          # Match: expect(foo).to be_empty (but not .not_to be_empty)
          # @!method empty_check?(node)
          def_node_matcher :empty_check?, <<~PATTERN
            (send
              (send nil? :expect $_subject)
              :to
              (send nil? :be_empty))
          PATTERN

          # expect(...).to is always a regular send, never safe navigation
          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            # Only look at expect(...).to/not_to calls
            return unless node.method?(:to) || node.method?(:to_not) || node.method?(:not_to)

            check_for_redundant_pair(node)
          end

          private

          def check_for_redundant_pair(node)
            # Check if this is a type check
            if (subject, type = type_check?(node))
              check_for_matching_empty(node, subject, type, :type_first)
            # Check if this is an empty check
            elsif (subject = empty_check?(node))
              check_for_matching_type(node, subject, :empty_first)
            end
          end

          def check_for_matching_empty(type_node, subject, type, order)
            # Look for a matching empty check after this type check
            sibling = next_expectation(type_node)
            return unless sibling

            empty_subject = empty_check?(sibling)
            return unless empty_subject
            return unless subjects_match?(subject, empty_subject)

            register_offense(type_node, sibling, type, order)
          end

          def check_for_matching_type(empty_node, subject, order)
            # Look for a matching type check after this empty check
            sibling = next_expectation(empty_node)
            return unless sibling

            type_subject, type = type_check?(sibling)
            return unless type_subject
            return unless subjects_match?(subject, type_subject)

            register_offense(sibling, empty_node, type, order)
          end

          def register_offense(type_node, empty_node, type, order)
            literal = type == :Array ? '[]' : '{}'
            # Always report on the first of the two expectations
            first_node = order == :type_first ? type_node : empty_node
            second_node = order == :type_first ? empty_node : type_node

            add_offense(first_node, message: format(MSG, literal: literal)) do |corrector|
              # Replace first expectation with eq([]) or eq({})
              corrector.replace(first_node, build_eq_expectation(type_node, type))

              # Remove from newline after first node through the line containing second node
              # Get the range of second line including leading whitespace but not trailing newline
              second_line_range = range_by_whole_lines(second_node.source_range)

              # We want to remove from the end of the first node to the end of the second line
              # including the trailing newline
              start_pos = first_node.source_range.end_pos
              end_pos = second_line_range.end_pos

              range_to_remove = range_between(start_pos, end_pos)
              corrector.remove(range_to_remove)
            end
          end

          def next_expectation(node)
            # Find the next sibling expectation
            # The node is a send node like: expect(foo).to be_empty
            # We need to find its siblings in the parent block
            parent = node.parent
            return unless parent

            # If parent is a begin block, get siblings from it
            siblings = if parent.begin_type?
                         parent.children
                       else
                         # Otherwise, try to get siblings from the grandparent
                         parent.parent&.children || []
                       end

            index = siblings.index(node)
            return unless index

            # Look ahead for next expect call (allowing whitespace/comments between)
            siblings[(index + 1)..-1]&.find do |sibling|
              expectation?(sibling)
            end
          end

          def expectation?(node)
            return false unless node.respond_to?(:send_type?)
            return false unless node.send_type?

            node.method?(:to) || node.method?(:to_not) || node.method?(:not_to)
          end

          def subjects_match?(subject1, subject2)
            subject1.source == subject2.source
          end

          def build_eq_expectation(type_node, type)
            # Extract the subject from expect(subject)
            expect_call = type_node.receiver
            subject = expect_call.first_argument

            literal = type == :Array ? '[]' : '{}'
            "expect(#{subject.source}).to eq(#{literal})"
          end
        end
      end
    end
  end
end
