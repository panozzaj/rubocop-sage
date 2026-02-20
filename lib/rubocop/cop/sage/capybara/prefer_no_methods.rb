# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module Capybara
        # Use `has_no_*?` instead of `!has_*?` for Capybara matchers.
        #
        # When using asynchronous drivers, negating `has_*?` methods can lead to
        # false results because the check happens immediately without waiting.
        # Capybara's `has_no_*?` methods properly wait for elements to disappear.
        #
        # @example
        #   # bad
        #   !page.has_xpath?('a')
        #   !page.has_css?('.flash')
        #   !page.has_selector?('.modal')
        #   !page.has_content?('Error')
        #   !page.has_link?('Click me')
        #   !page.has_button?('Submit')
        #   !page.has_field?('Name')
        #
        #   # good
        #   page.has_no_xpath?('a')
        #   page.has_no_css?('.flash')
        #   page.has_no_selector?('.modal')
        #   page.has_no_content?('Error')
        #   page.has_no_link?('Click me')
        #   page.has_no_button?('Submit')
        #   page.has_no_field?('Name')
        #
        class PreferNoMethods < Base
          extend AutoCorrector
          requires_gem 'capybara'

          MSG = 'Use `%<preferred>s` instead of `!%<current>s` to handle async behavior correctly.'

          RESTRICT_ON_SEND = %i[!].freeze

          CAPYBARA_MATCHERS = %w[
            has_xpath?
            has_css?
            has_selector?
            has_content?
            has_text?
            has_link?
            has_button?
            has_field?
            has_checked_field?
            has_unchecked_field?
            has_select?
            has_table?
          ].freeze

          # @!method negated_capybara_matcher?(node)
          def_node_matcher :negated_capybara_matcher?, <<~PATTERN
            (send
              (send $_ ${:has_xpath? :has_css? :has_selector? :has_content? :has_text?
                         :has_link? :has_button? :has_field? :has_checked_field?
                         :has_unchecked_field? :has_select? :has_table?} ...)
              :!)
          PATTERN

          # Matches :! (negation operator), not a regular method — on_csend not applicable
          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            negated_capybara_matcher?(node) do |receiver, method|
              preferred_method = method.to_s.sub('has_', 'has_no_')
              message = format(MSG, preferred: preferred_method, current: method)

              add_offense(node, message: message) do |corrector|
                corrector.replace(node, build_corrected_source(node, receiver, preferred_method))
              end
            end
          end

          private

          def build_corrected_source(node, receiver, preferred_method)
            # Get the original has_* method call
            original_call = node.receiver

            # Build the corrected version
            receiver_source = receiver.source
            args = original_call.arguments.map(&:source).join(', ')

            if args.empty?
              "#{receiver_source}.#{preferred_method}"
            else
              "#{receiver_source}.#{preferred_method}(#{args})"
            end
          end
        end
      end
    end
  end
end
