require 'rake_helper'

RSpec.describe 'rake_option', type: :task do
  before do
    # loggerをモック
    allow(Rails.logger).to receive(:error)
  end

  describe 'without_option' do
    subject(:task) { Rake.application['rake_option:without_option'] }

    it 'ログに出力されること' do
      task.invoke

      expect(Rails.logger).to have_received(:error).with('foo')
    end
  end

  describe 'with_option' do
    subject(:task) { Rake.application['rake_option:with_option'] }

    it 'ログに出力されること' do
      task.invoke('foo', 'true')

      expect(Rails.logger).to have_received(:error).with('foo, type => String')
      expect(Rails.logger).to have_received(:error).with('true, type => String')
    end
  end

  describe 'with_env' do
    subject(:task) { Rake.application['rake_option:with_env'] }

    before do
      allow(ENV).to receive(:fetch).and_call_original # fooとbar以外は元の実装のままにする
      allow(ENV).to receive(:fetch).with('foo').and_return('1')
      allow(ENV).to receive(:fetch).with('bar').and_return('false')
    end

    it 'ログに出力されること' do
      task.invoke('foo=1', 'bar=false')

      expect(Rails.logger).to have_received(:error).with('1, type => String')
      expect(Rails.logger).to have_received(:error).with('false, type => String')
    end
  end
end