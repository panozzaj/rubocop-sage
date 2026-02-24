# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sage::RSpec::PreferHaveHttpStatus, :config do
  let(:gem_versions) { { 'rspec-core' => '3.0' } }

  context 'with category predicates' do
    it 'registers an offense for be_successful' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_successful')
        it 'succeeds' do
          %{code}
          ^{code} Use `have_http_status(:success)` instead of `be_successful` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'succeeds' do
          expect(response).to have_http_status(:success)
        end
      RUBY
    end

    it 'registers an offense for be_redirect' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_redirect')
        it 'redirects' do
          %{code}
          ^{code} Use `have_http_status(:redirect)` instead of `be_redirect` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'redirects' do
          expect(response).to have_http_status(:redirect)
        end
      RUBY
    end

    it 'registers an offense for be_server_error' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_server_error')
        it 'errors' do
          %{code}
          ^{code} Use `have_http_status(:server_error)` instead of `be_server_error` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'errors' do
          expect(response).to have_http_status(:server_error)
        end
      RUBY
    end

    it 'registers an offense for be_not_found' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_not_found')
        it 'is missing' do
          %{code}
          ^{code} Use `have_http_status(:not_found)` instead of `be_not_found` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is missing' do
          expect(response).to have_http_status(:not_found)
        end
      RUBY
    end
  end

  context 'with specific status predicates' do
    it 'registers an offense for be_ok' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_ok')
        it 'is ok' do
          %{code}
          ^{code} Use `have_http_status(:ok)` instead of `be_ok` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is ok' do
          expect(response).to have_http_status(:ok)
        end
      RUBY
    end

    it 'registers an offense for be_created' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_created')
        it 'creates' do
          %{code}
          ^{code} Use `have_http_status(:created)` instead of `be_created` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'creates' do
          expect(response).to have_http_status(:created)
        end
      RUBY
    end

    it 'registers an offense for be_unauthorized' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_unauthorized')
        it 'is unauthorized' do
          %{code}
          ^{code} Use `have_http_status(:unauthorized)` instead of `be_unauthorized` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      RUBY
    end

    it 'registers an offense for be_forbidden' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_forbidden')
        it 'is forbidden' do
          %{code}
          ^{code} Use `have_http_status(:forbidden)` instead of `be_forbidden` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      RUBY
    end

    it 'registers an offense for be_unprocessable with numeric replacement' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_unprocessable')
        it 'is unprocessable' do
          %{code}
          ^{code} Use `have_http_status(422)` instead of `be_unprocessable` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is unprocessable' do
          expect(response).to have_http_status(422)
        end
      RUBY
    end
  end

  context 'with negation' do
    it 'registers an offense for not_to' do
      expect_offense(<<~RUBY, code: 'expect(response).not_to be_not_found')
        it 'is found' do
          %{code}
          ^{code} Use `have_http_status(:not_found)` instead of `be_not_found` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'is found' do
          expect(response).not_to have_http_status(:not_found)
        end
      RUBY
    end

    it 'registers an offense for to_not' do
      expect_offense(<<~RUBY, code: 'expect(response).to_not be_server_error')
        it 'does not error' do
          %{code}
          ^{code} Use `have_http_status(:server_error)` instead of `be_server_error` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'does not error' do
          expect(response).to_not have_http_status(:server_error)
        end
      RUBY
    end
  end

  context 'with last_response (Rack::Test)' do
    it 'registers an offense for last_response' do
      expect_offense(<<~RUBY, code: 'expect(last_response).to be_successful')
        it 'succeeds' do
          %{code}
          ^{code} Use `have_http_status(:success)` instead of `be_successful` [...]
        end
      RUBY

      expect_correction(<<~RUBY)
        it 'succeeds' do
          expect(last_response).to have_http_status(:success)
        end
      RUBY
    end
  end

  context 'without autocorrect (no exact equivalent)' do
    it 'registers an offense for be_redirection without autocorrect' do
      expect_offense(<<~RUBY, code: 'expect(response).to be_redirection')
        it 'redirects' do
          %{code}
          ^{code} Avoid `be_redirection` on response objects [...]
        end
      RUBY

      expect_no_corrections
    end
  end

  context 'when not an offense' do
    it 'does not register an offense for have_http_status' do
      expect_no_offenses(<<~RUBY)
        it 'succeeds' do
          expect(response).to have_http_status(:success)
        end
      RUBY
    end

    it 'does not register an offense for non-response objects' do
      expect_no_offenses(<<~RUBY)
        it 'is valid' do
          expect(user).to be_valid
        end
      RUBY
    end

    it 'does not register an offense for non-response receiver with response predicate' do
      expect_no_offenses(<<~RUBY)
        it 'succeeds' do
          expect(result).to be_successful
        end
      RUBY
    end

    it 'does not register an offense for be_informational (no equivalent)' do
      expect_no_offenses(<<~RUBY)
        it 'is informational' do
          expect(response).to be_informational
        end
      RUBY
    end

    it 'does not register an offense for be_client_error (no equivalent)' do
      expect_no_offenses(<<~RUBY)
        it 'errors' do
          expect(response).to be_client_error
        end
      RUBY
    end
  end
end
