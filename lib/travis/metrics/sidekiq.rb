require 'metriks'

module Travis
  module Metrics
    class Sidekiq
      def call(worker, message, queue, &block)
        ::Metriks.timer("sidekiq.jobs.#{queue}.perform").time(&block)
      rescue Exception
        ::Metriks.meter("sidekiq.jobs.#{queue}.failure").mark
        raise
      end
    end
  end
end
