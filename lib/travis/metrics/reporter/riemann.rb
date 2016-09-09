require 'metriks/reporter/riemann'

module Travis
  class Metrics
    module Reporter
      class Riemann < Struct.new(:config)
        require 'riemann/client'
        #MSGS = {
          #setup: 'Using Librato metrics reporter (source: %s, account: %s)',
          #error: 'Librato error: %s (%s)'
        #}

        def setup
          #return unless host
          #logger.info MSGS[:setup] % [source, email]
          Metriks::Reporter::Riemann.new(client, interval: interval)
        end

        private

          def client
            ::Riemann::Client.new(host,port)
          end

          def host
            "host"
            #config[:host]
          end

          def port
            "port"
            #config[:port]
          end

          def interval
            config[:interval]
          end

          #def on_error(e)
            #logger.error MSGS[:error] % [e.message, e.response.body]
          #end
      end
    end
  end
end
