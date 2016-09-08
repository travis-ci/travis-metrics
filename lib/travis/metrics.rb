require 'metriks'
require 'travis/metrics/reporter/librato'
require 'travis/metrics/reporter/graphite'

module Travis
  class Metrics
    class << self
      attr_reader :reporter

      MSGS = {
        no_reporter: 'No metrics reporter configured.',
        error:       '"Exception while starting metrics reporter: %s"'
      }

      def setup(config, logger)
        config[:reporter] ? start(config, logger) : logger.info(MSGS[:no_reporter])
        new
      rescue Exception => e
        logger.error [e.message, e.backtrace].join("\n")
      end

      def start(config, logger)
        adapter   = config[:reporter]
        config    = config[adapter.to_sym] || {}
        @reporter = Reporter.send(adapter, config, logger)
        reporter.start
      end

      def started?
        !!reporter
      end
    end

    def count(key)
      Metriks.counter(key).increment
    end

    def meter(key)
      Metriks.meter(key).mark
    end

    def time(key, &block)
      Metriks.timer(key).time(&block)
    end

    def gauge(key, value)
      Metriks.gauge(key).set(value)
    end
  end
end
