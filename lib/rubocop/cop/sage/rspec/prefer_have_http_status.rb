# frozen_string_literal: true

module RuboCop
  module Cop
    module Sage
      module RSpec
        # Use `have_http_status` instead of predicate matchers on response objects.
        #
        # Predicate matchers like `be_successful` delegate to `response.successful?`
        # and produce vague failure messages because `ActionDispatch::TestResponse#inspect`
        # is an unreadable blob. The `have_http_status` matcher provides clear failure
        # messages that include the actual status code.
        #
        # @example
        #   # bad - failure message: "expected response.successful? to be truthy, got false"
        #   expect(response).to be_successful
        #
        #   # good - failure message: "expected the response to have a success status code (2xx) but it was 302"
        #   expect(response).to have_http_status(:success)
        #
        #   # bad
        #   expect(response).to be_ok
        #
        #   # good
        #   expect(response).to have_http_status(:ok)
        #
        #   # bad
        #   expect(response).not_to be_not_found
        #
        #   # good
        #   expect(response).not_to have_http_status(:not_found)
        #
        #   # bad - no autocorrect (be_redirection checks full 3xx range,
        #   #   have_http_status(:redirect) only checks [301, 302, 303, 307, 308])
        #   expect(response).to be_redirection
        #
        class PreferHaveHttpStatus < Base
          extend AutoCorrector
          requires_gem 'rspec-core'

          MSG = 'Use `have_http_status(%<replacement>s)` instead of `%<predicate>s` for clearer failure messages.'
          MSG_NO_AUTOCORRECT = 'Avoid `%<predicate>s` on response objects — predicate matchers produce ' \
                               'vague failure messages. Use an explicit status code assertion instead.'

          RESTRICT_ON_SEND = %i[to to_not not_to].freeze

          # Maps predicate matcher names to have_http_status arguments.
          PREDICATE_MAP = {
            # Category predicates
            be_successful: ':success',
            be_redirect: ':redirect',
            be_server_error: ':server_error',
            be_not_found: ':not_found',
            # Specific status predicates
            be_ok: ':ok',
            be_created: ':created',
            be_accepted: ':accepted',
            be_no_content: ':no_content',
            be_moved_permanently: ':moved_permanently',
            be_bad_request: ':bad_request',
            be_unauthorized: ':unauthorized',
            be_forbidden: ':forbidden',
            be_method_not_allowed: ':method_not_allowed',
            be_not_acceptable: ':not_acceptable',
            be_request_timeout: ':request_timeout',
            be_precondition_failed: ':precondition_failed',
            be_unprocessable: '422'
          }.freeze

          # Predicates flagged without autocorrect because there is no
          # semantically equivalent have_http_status argument.
          # be_redirection checks full 3xx range; have_http_status(:redirect)
          # only checks [301, 302, 303, 307, 308].
          NO_AUTOCORRECT_PREDICATES = %i[be_redirection].freeze

          # @!method response_predicate_matcher?(node)
          def_node_matcher :response_predicate_matcher?, <<~PATTERN
            (send
              (send nil? :expect (send nil? {:response :last_response}))
              {:to :to_not :not_to}
              (send nil? $#known_predicate?))
          PATTERN

          # expect(...).to is always a regular send, never safe navigation
          def on_send(node) # rubocop:disable InternalAffairs/OnSendWithoutOnCSend
            response_predicate_matcher?(node) do |predicate|
              if (replacement = PREDICATE_MAP[predicate])
                message = format(MSG, replacement: replacement, predicate: predicate)
                add_offense(node, message: message) do |corrector|
                  matcher_node = node.last_argument
                  corrector.replace(matcher_node, "have_http_status(#{replacement})")
                end
              else
                add_offense(node, message: format(MSG_NO_AUTOCORRECT, predicate: predicate))
              end
            end
          end

          private

          def known_predicate?(method_name)
            PREDICATE_MAP.key?(method_name) || NO_AUTOCORRECT_PREDICATES.include?(method_name)
          end
        end
      end
    end
  end
end
