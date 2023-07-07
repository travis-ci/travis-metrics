# frozen_string_literal: true

describe Travis::Metrics::Reporter::Librato do
  subject        { reporter.setup }

  let(:config)   { { email: email, token: token, source: 'source' } }
  let(:email)    { 'anja@travis-ci.org' }
  let(:token)    { 'token' }
  let(:reporter) { described_class.new(config, logger) }

  describe 'setup' do
    describe 'returns nil if email is missing' do
      let(:email) { nil }

      it { expect(subject).to be_nil }
    end

    describe 'returns nil if token is missing' do
      let(:token) { nil }

      it { expect(subject).to be_nil }
    end

    describe 'starts a librato reporter' do
      let(:metriks) { double('metriks', start: nil) }

      before do
        allow(Metriks::LibratoMetricsReporter).to receive(:new).and_return(metriks)
        reporter.setup
      end

      it { expect(metriks).to have_received(:start) }
      it { expect(log).to include 'Using Librato metrics reporter (source: source, account: anja@travis-ci.org)' }
    end

    describe 'on_error' do
      let(:error) { StandardError.new('message') }

      before do
        allow(error).to receive(:response).and_return(double(body: 'body'))
        allow_any_instance_of(Metriks::LibratoMetricsReporter).to receive(:write).and_raise(error)
        reporter.setup
        reporter.reporter.flush
      end

      it { expect(stdout.string).to include 'Librato error: message (body)' }
    end
  end
end
