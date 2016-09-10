require 'metriks'
require 'travis/metrics/reporter/librato'
require 'travis/metrics/reporter/graphite'
require 'travis/metrics/reporter/riemann'

module Travis
  class Metrics
    class << self
      MSGS = {
        no_reporter: 'No metrics reporter configured.',
        error:       '"Exception while starting metrics reporter: %s"'
      }

      attr_reader :reporter

      def setup(config, logger)
        config[:reporter] ? start(config, logger) : logger.info(MSGS[:no_reporter])
        new
      rescue Exception => e
        logger.error [e.message, e.backtrace].join("\n")
      end

      def start(config, logger)
        adapter   = config[:reporter]
        config    = config[adapter.to_sym] || {}
        const     = Reporter.const_get(adapter.capitalize) rescue nil
        @reporter = const && const.new(config, logger)
        reporter.setup if reporter
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
