# frozen_string_literal: true

require 'travis/metrics'
require 'support/logger'

RSpec.configure do |c|
  c.include Support::Logger
end
