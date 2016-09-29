require 'metriks/librato_metrics_reporter'

module Travis
  class Metrics
    module Reporter
      class Librato < Struct.new(:config, :logger)
        MSGS = {
          setup: 'Using Librato metrics reporter (source: %s, account: %s)',
          error: 'Librato error: %s (%s)'
        }

        attr_reader :reporter

        def setup
          return unless email && token
          logger.info MSGS[:setup] % [source, email]
          @reporter = Metriks::LibratoMetricsReporter.new(email, token, source: source, on_error: method(:on_error))
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
            [config[:source], dyno].compact.join('.')
          end

          def dyno
            ENV['DYNO']
          end

          def on_error(e)
            logger.error MSGS[:error] % [e.message, e.response.body]
          end
      end
    end
  end
end
