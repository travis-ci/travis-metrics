# frozen_string_literal: true

require 'metriks'

module Travis
  class Metrics
    class Sidekiq
      def call(_worker, _message, queue, &)
        ::Metriks.timer("sidekiq.jobs.#{queue}.perform").time(&)
      rescue Exception
        ::Metriks.meter("sidekiq.jobs.#{queue}.failure").mark
        raise
      end
    end
  end
end
