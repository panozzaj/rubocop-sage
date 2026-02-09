# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Rails
        # Don't pass a block to `.all` - it will be silently ignored.
        #
        # `ActiveRecord::Base.all` returns a relation and does not yield
        # to a block. Passing a block is almost certainly a bug where the
        # author meant `.all.each` or `.find_each`.
        #
        # @example
        #   # bad
        #   User.all do |user|
        #     user.do_something
        #   end
        #
        #   # bad
        #   User.all { |user| user.do_something }
        #
        #   # good
        #   User.find_each do |user|
        #     user.do_something
        #   end
        #
        #   # good
        #   User.all.each do |user|
        #     user.do_something
        #   end
        #
        class AllWithBlock < Base
          MSG = '`.all` ignores blocks. Use `.find_each` or `.all.each` instead.'

          # @!method all_with_block?(node)
          def_node_matcher :all_with_block?, <<~PATTERN
            (block (send _ :all) ...)
          PATTERN

          def on_block(node)
            return unless all_with_block?(node)

            add_offense(node.send_node)
          end
        end
      end
    end
  end
end
