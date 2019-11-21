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
        Metriks.enable_hdrhistogram if Metriks.respond_to?(:enable_hdrhistogram)
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

    def count(key, value = 1)
      Metriks.counter(key, value).increment
    end

    def meter(key, value = 1)
      Metriks.meter(key).mark(value)
    end

    def gauge(key, value)
      Metriks.gauge(key).set(value)
    end

    def time(key, &block)
      Metriks.timer(key).time(&block)
    end
  end
end
