# frozen_string_literal: true

require 'metriks/reporter/graphite'

module Travis
  class Metrics
    module Reporter
      class Graphite < Struct.new(:config, :logger)
        MSGS = {
          setup: 'Using Graphite metrics reporter (host: %s, port: %s)',
          error: 'Graphite error: %s (%s)'
        }.freeze

        attr_reader :reporter

        def setup
          return unless host

          logger.info format(MSGS[:setup], host, port)
          @reporter = Metriks::Reporter::Graphite.new(host, port, interval: interval, on_error: method(:on_error))
          reporter.start
        end

        private

        def host
          config[:host]
        end

        def port
          config[:port]
        end

        def interval
          config[:interval]
        end

        def on_error(e)
          logger.error format(MSGS[:error], e.message, e.respond_to?(:response) ? e.response.body : '?')
        end
      end
    end
  end
end
