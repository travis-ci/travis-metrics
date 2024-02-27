# frozen_string_literal: true

require 'metriks/librato_metrics_reporter'

module Travis
  class Metrics
    module Reporter
      class Librato < Struct.new(:config, :logger)
        MSGS = {
          setup: 'Using Librato metrics reporter (source: %s, account: %s)',
          error: 'Librato error: %s (%s)'
        }.freeze

        attr_reader :reporter

        def setup
          return unless email && token

          logger.info format(MSGS[:setup], source, email)
          @reporter = Metriks::LibratoMetricsReporter.new(email, token,
                                                          source: source,
                                                          on_error: method(:on_error),
                                                          percentiles: [0.95, 0.99, 0.999, 1.0],
                                                          interval: config[:interval])
          reporter.start
        end

        private

        def email
          config[:email]
        end

        def token
          config[:token]
        end

        def source
          [config[:source] || ENV['HEROKU_APP_NAME'], dyno].compact.join('.')
        end

        def dyno
          ENV['DYNO']
        end

        def on_error(e)
          logger.error format(MSGS[:error], e.message, e.response.body)
        end
      end
    end
  end
end
