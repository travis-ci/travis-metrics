describe Travis::Metrics::Reporter::Graphite do
  let(:config)   { { host: host, port: 1234, interval: 0 } }
  let(:host)     { 'https://example.com' }
  let(:reporter) { described_class.new(config, logger) }
  subject        { reporter.setup }

  def log
    reporter.setup
    super
  end

  describe 'setup' do
    describe 'returns nil if host is missing' do
      let(:host) { nil }
      it { expect(subject).to be_nil }
    end

    describe 'returns a graphite reporter' do
      it { expect(subject).to be_kind_of(Metriks::Reporter::Graphite) }
      it { expect(log).to include "Using Graphite metrics reporter (host: #{host}, port: 1234)" }
    end

    describe 'on_error' do
      let(:error) { StandardError.new('message') }
      before { allow(error).to receive(:response).and_return(double(body: 'body')) }
      before { allow_any_instance_of(Metriks::Reporter::Graphite).to receive(:write).and_raise(error) }

      before do
        subject.start
        sleep 0.1 # ugh.
        subject.stop
      end

      it { expect(stdout.string).to include 'Graphite error: message (body)' }
    end
  end
end
