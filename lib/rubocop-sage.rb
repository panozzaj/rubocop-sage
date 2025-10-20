# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/sage'
require_relative 'rubocop/sage/version'
require_relative 'rubocop/sage/inject'

RuboCop::Sage::Inject.defaults!

require_relative 'rubocop/cop/sage_cops'
