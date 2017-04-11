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

      def setup(config, logger)
        reporter = start(config, logger)
        logger.debug(MSGS[:no_reporter]) unless reporter
        new(reporter)
      rescue Exception => e
        logger.error [e.message, e.backtrace].join("\n")
      end

      def start(config, logger)
        return unless adapter = config[:reporter]
        config   = config[adapter.to_sym] || {}
        const    = Reporter.const_get(adapter.capitalize) rescue nil
        reporter = const && const.new(config, logger)
        reporter.setup && reporter if reporter
      end
    end

    attr_reader :reporter

    def initialize(reporter)
      @reporter = reporter
    end

    def count(key)
      Metriks.counter(key).increment if reporter
    end

    def meter(key)
      Metriks.meter(key).mark if reporter
    end

    def gauge(key, value)
      Metriks.gauge(key).set(value) if reporter
    end

    def time(key, &block)
      reporter ? Metriks.timer(key).time(&block) : yield
    end
  end
end
