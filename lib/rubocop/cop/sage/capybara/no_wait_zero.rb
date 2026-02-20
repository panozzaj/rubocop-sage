# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Capybara
        # Don't use `wait: 0` in Capybara finders as it disables waiting.
        #
        # Using `wait: 0` explicitly disables Capybara's waiting behavior, which leads
        # to flaky tests. Elements may not be ready yet when the finder executes,
        # causing intermittent failures especially in CI environments.
        #
        # @example
        #   # bad
        #   page.first('.navigation-menu', wait: 0).click
        #   page.all('.items', wait: 0).count
        #   page.find('.button', wait: 0)
        #
        #   # good
        #   page.first('.navigation-menu').click
        #   page.all('.items').count
        #   page.find('.button')
        #
        #   # also acceptable - explicit positive wait time
        #   page.first('.navigation-menu', wait: 5).click
        #
        class NoWaitZero < Base
          extend AutoCorrector
          requires_gem 'capybara'

          MSG = 'Avoid `wait: 0` as it disables waiting and causes flaky tests. Remove the option to use default waiting.'

          RESTRICT_ON_SEND = %i[first all find].freeze

          # @!method wait_zero_option?(node)
          def_node_matcher :wait_zero_option?, <<~PATTERN
            (send _ {:first :all :find} ... (hash <$(pair (sym :wait) (int 0)) ...>))
          PATTERN

          def on_send(node)
            wait_zero_option?(node) do |pair_node|
              add_offense(pair_node) do |corrector|
                remove_wait_zero(corrector, node, pair_node)
              end
            end
          end
          alias_method :on_csend, :on_send

          private

          def remove_wait_zero(corrector, node, pair_node)
            hash_node = pair_node.parent

            if hash_node.pairs.size == 1
              # If this is the only hash pair, remove the entire hash argument
              remove_hash_argument(corrector, node, hash_node)
            else
              # If there are other pairs, just remove this pair
              remove_pair_from_hash(corrector, pair_node, hash_node)
            end
          end

          def remove_hash_argument(corrector, node, hash_node)
            # Find the position to remove including the comma before it
            arg_index = node.arguments.index(hash_node)

            if arg_index > 0
              # Remove the comma and the hash
              prev_arg = node.arguments[arg_index - 1]
              range = prev_arg.source_range.end.join(hash_node.source_range.end)
              corrector.remove(range)
            else
              # Hash is the first/only argument
              corrector.remove(hash_node)
            end
          end

          def remove_pair_from_hash(corrector, pair_node, hash_node)
            pairs = hash_node.pairs
            pair_index = pairs.index(pair_node)

            if pair_index == 0 && pairs.size > 1
              # First pair: remove the pair and the comma after
              range = pair_node.source_range.begin.join(pairs[1].source_range.begin)
              corrector.remove(range)
            else
              # Last or middle pair: remove the comma before and the pair
              range = pairs[pair_index - 1].source_range.end.join(pair_node.source_range.end)
              corrector.remove(range)
            end
          end
        end
      end
    end
  end
end
