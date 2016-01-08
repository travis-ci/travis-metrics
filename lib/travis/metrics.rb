require 'metriks'

# TODO clean this up

module Travis
  module Metrics
    module Reporter
      class << self
        def librato(config, logger)
          require 'metriks/librato_metrics_reporter'
          email, token = config[:email], config[:token]
          return unless email && token
          source = config[:source]
          source = "#{source}.#{ENV['DYNO']}" if ENV.key?('DYNO')
          on_error = proc {|ex| puts "librato error: #{ex.message} (#{ex.response.body})"}
          puts "Using Librato metrics reporter (source: #{source}, account: #{email})"
          Metriks::LibratoMetricsReporter.new(email, token, source: source, on_error: on_error)
        end

        def graphite(config, logger)
          require 'metriks/reporter/graphite'
          host, port = *config.values_at(:host, :port)
          return unless host
          puts "Using Graphite metrics reporter (host: #{host}, port: #{port})"
          Metriks::Reporter::Graphite.new(host, port)
        end
      end
    end

    METRICS_VERSION = 'v1'

    class << self
      attr_reader :reporter

      def setup(config, logger)
        if adapter = config[:reporter]
          config = config[adapter.to_sym] || {}
          @reporter = Reporter.send(adapter, config, logger)
        end
        reporter ? reporter.start : logger.info('No metrics reporter configured.')
        self
      rescue Exception => e
        puts "Exception while starting metrics reporter: #{e.message}", e.backtrace
      end

      def started?
        !!reporter
      end

      def meter(event, options = {})
        return if !started? || options[:level] == :debug

        event = "#{METRICS_VERSION}.#{event}"
        started_at, finished_at = options[:started_at], options[:finished_at]

        if finished_at
          Metriks.timer(event).update(finished_at - started_at)
        else
          Metriks.meter(event).mark
        end
      end
    end
  end
end
