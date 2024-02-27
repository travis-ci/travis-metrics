# frozen_string_literal: true

require 'logger'

module Support
  module Logger
    def self.included(other)
      other.class_eval do
        let(:stdout) { StringIO.new }
        let(:log)    { stdout.string }
        let(:logger) { ::Logger.new(stdout) }
      end
    end
  end
end
