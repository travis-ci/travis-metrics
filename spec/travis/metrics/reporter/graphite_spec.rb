# frozen_string_literal: true

describe Travis::Metrics::Reporter::Graphite do
  subject        { reporter.setup }

  let(:config)   { { host: host, port: 1234, interval: 0 } }
  let(:host)     { 'https://example.com' }
  let(:reporter) { described_class.new(config, logger) }

  def log
    reporter.setup
    super
  end

  describe 'setup' do
    describe 'returns nil if host is missing' do
      let(:host) { nil }

      it { expect(subject).to be_nil }
    end

    describe 'starts a graphite reporter' do
      let(:metriks) { double('metriks', start: nil) }

      before do
        allow(Metriks::Reporter::Graphite).to receive(:new).and_return(metriks)
        reporter.setup
      end

      it { expect(metriks).to have_received(:start) }
      it { expect(log).to include "Using Graphite metrics reporter (host: #{host}, port: 1234)" }
    end

    describe 'on_error' do
      let(:error) { StandardError.new('message') }

      before do
        allow(error).to receive(:response).and_return(double(body: 'body'))
        allow_any_instance_of(Metriks::Reporter::Graphite).to receive(:write).and_raise(error)
        reporter.setup
        reporter.reporter.start
        sleep 0.1 # ugh.
        reporter.reporter.stop
      end

      it { expect(stdout.string).to include 'Graphite error: message (body)' }
    end
  end
end
