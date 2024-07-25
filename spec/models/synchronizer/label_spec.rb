# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Synchronizer::Label, type: :model do
  describe '#call' do
    before do
      allow(GitHub::Label).to receive(:registered_by)
      allow(Label).to receive(:synchronize)
    end

    let(:synchronizer) { Synchronizer::Label.new }
    let(:repository) { FactoryBot.create(:repository) }

    it 'GitHubから対象の Label を取得する(処理を呼び出す)こと' do
      synchronizer.call({ repository: })
      expect(GitHub::Label).to have_received(:registered_by)
    end

    it '取得したデータをデータベースへ同期させる(処理を呼び出す)こと' do
      synchronizer.call({ repository: })
      expect(Label).to have_received(:synchronize)
    end
  end
end
