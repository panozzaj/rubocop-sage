# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Capybara
        # Avoid explicit `visible: true` in Capybara matchers.
        #
        # The `visible: true` option is the default behavior for Capybara matchers,
        # making it redundant. If you need to be explicit about visibility checking,
        # consider whether the default behavior is sufficient or disable this cop
        # selectively with comments.
        #
        # @example
        #   # bad
        #   expect(page).to have_selector('.container', visible: true)
        #   expect(page).to have_no_selector('.container', visible: true)
        #   page.has_css?('.container', visible: true)
        #   page.has_no_css?('.container', visible: true)
        #
        #   # good
        #   expect(page).to have_selector('.container')
        #   expect(page).to have_no_selector('.container')
        #   page.has_css?('.container')
        #   page.has_no_css?('.container')
        #
        #   # acceptable (if you need to check for invisible elements)
        #   expect(page).to have_selector('.container', visible: false)
        #   expect(page).to have_selector('.container', visible: :all)
        #
        class AvoidExplicitVisible < Base
          extend AutoCorrector

          MSG = 'Avoid explicit `visible: true` as it is the default behavior.'

          RESTRICT_ON_SEND = %i[
            has_selector? has_no_selector?
            has_css? has_no_css?
            has_xpath? has_no_xpath?
            has_content? has_no_content?
            has_text? has_no_text?
            has_link? has_no_link?
            has_button? has_no_button?
            has_field? has_no_field?
            has_checked_field? has_no_checked_field?
            has_unchecked_field? has_no_unchecked_field?
            has_select? has_no_select?
            has_table? has_no_table?
            have_selector have_no_selector
            have_css have_no_css
            have_xpath have_no_xpath
            have_content have_no_content
            have_text have_no_text
            have_link have_no_link
            have_button have_no_button
            have_field have_no_field
            have_checked_field have_no_checked_field
            have_unchecked_field have_no_unchecked_field
            have_select have_no_select
            have_table have_no_table
          ].freeze

          # @!method visible_true_option?(node)
          def_node_matcher :visible_true_option?, <<~PATTERN
            (send _ _ ... (hash <$(pair (sym :visible) (true)) ...>))
          PATTERN

          def on_send(node)
            visible_true_option?(node) do |pair_node|
              add_offense(pair_node) do |corrector|
                remove_visible_true(corrector, node, pair_node)
              end
            end
          end
          alias_method :on_csend, :on_send

          private

          def remove_visible_true(corrector, node, pair_node)
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
