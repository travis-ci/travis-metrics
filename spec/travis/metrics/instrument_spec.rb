describe Travis::Metrics do
  let(:metrics) { described_class.new(double('reporter')) }
  let(:key)     { :foo }
  let(:obj)     { double }

  describe 'count' do

    it 'increments a counter' do
      expect(Metriks).to receive(:counter).with(key).and_return(obj)
      expect(obj).to receive(:increment)
      metrics.count(key)
    end
  end

  describe 'meter' do
    it 'meters an instrument' do
      expect(Metriks).to receive(:meter).with(key).and_return(obj)
      expect(obj).to receive(:mark)
      metrics.meter(key)
    end
  end

  describe 'time' do
    it 'times a block' do
      called = false
      block = -> { called = true }
      expect(Metriks).to receive(:timer).with(key).and_return(obj)
      expect(obj).to receive(:time).and_yield
      metrics.time(key, &block)
      expect(called).to be true
    end
  end

  describe 'gauge' do
    let(:value) { 1 }

    it 'gauges a value' do
      expect(Metriks).to receive(:gauge).with(key).and_return(obj)
      expect(obj).to receive(:set).with(value)
      metrics.gauge(key, value)
    end
  end
end
