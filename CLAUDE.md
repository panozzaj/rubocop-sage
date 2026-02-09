# RuboCop Sage - Claude Code Instructions

## Adding New Cops

### Prior Art Research

When researching prior art, list each source checked and explain why it doesn't
cover the case (not just "no prior art found"). This helps validate that the cop
is genuinely novel. Sources to check:

1. **rubocop-rails** — Cops list and GitHub issues.
2. **rubocop-rspec** / **rubocop-rspec_rails** — For test-related cops.
3. **rubocop-performance** — For performance-related patterns.
4. **rubocop core (Lint, Style)** — Especially Lint cops for bug-like patterns.
5. **rubocop-capybara** — For Capybara-related cops.
6. **Ruby language warnings** — e.g. Ruby 3.4's `strict_unused_block`.
7. **GitHub issues on relevant repos** — Open/closed proposals.
