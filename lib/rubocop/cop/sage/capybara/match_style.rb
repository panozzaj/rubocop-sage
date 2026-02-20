# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Capybara
        # Prefer match: :first over .first with finders that return multiple elements.
        #
        # When using methods like `all`, `find_all`, etc., accessing `.first` on the result
        # can be flaky because the collection might not be fully loaded. Using `match: :first`
        # or the `first` finder method is more reliable.
        #
        # @example
        #   # bad
        #   page.all('.items').first
        #   page.all('.items').first.click
        #   page.all('.items').last
        #
        #   # good
        #   page.all('.items', match: :first)
        #   page.first('.items').click
        #   page.all('.items', minimum: 1).last
        #
        class MatchStyle < Base
          requires_gem 'capybara'
          MSG_FIRST = 'Use `page.first(...)` or `match: :first` instead of `page.all(...).first` for more reliable waiting.'
          MSG_LAST = 'Verify element count before using `.last` on `.all()` to avoid flaky tests. Use `count:` or `minimum:` option.'

          RESTRICT_ON_SEND = %i[first last].freeze

          # @!method all_method_call?(node)
          def_node_matcher :all_method_call?, <<~PATTERN
            (send (send _ {:all :find_all} ...) {:first :last})
          PATTERN

          # @!method has_count_option?(node)
          def_node_matcher :has_count_option?, <<~PATTERN
            (send _ {:all :find_all} ... (hash <(pair (sym {:count :minimum :maximum}) _) ...>))
          PATTERN

          def on_send(node)
            return unless all_method_call?(node)

            all_node = node.receiver
            method_name = node.method_name

            # Allow .last if count/minimum/maximum option is present
            if method_name == :last && has_count_option?(all_node)
              return
            end

            message = method_name == :first ? MSG_FIRST : MSG_LAST
            add_offense(node, message: message)
          end
          alias_method :on_csend, :on_send
        end
      end
    end
  end
end
