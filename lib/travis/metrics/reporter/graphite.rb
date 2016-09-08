require 'metriks/reporter/graphite'

module Travis
  class Metrics
    module Reporter
      class Graphite < Struct.new(:config, :logger)
        MSGS = {
          setup: 'Using Graphite metrics reporter (host: %s, port: %s)',
          error: 'Graphite error: %s (%s)'
        }

        def setup
          return unless host
          logger.info MSGS[:setup] % [host, port]
          Metriks::Reporter::Graphite.new(host, port, interval: interval, on_error: method(:on_error))
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
            logger.error MSGS[:error] % [e.message, e.respond_to?(:response) ? e.response.body : '?']
          end
      end
    end
  end
end
