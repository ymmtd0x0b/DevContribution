# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Newspaper::AssignedIssueSynchronizer, type: :model do
  describe '#call' do
    before do
      allow(Github::Issue).to receive(:assigned_by)
      allow(Newspaper::Synchronizer).to receive(:synchronize_issues)
      allow(Newspaper::Synchronizer).to receive(:synchronize_assigns)

      repository = FactoryBot.create(:repository)
      user = FactoryBot.create(:user)
      Newspaper::AssignedIssueSynchronizer.new.call({ repository:, user: })
    end

    it 'GitHubから対象の Issue を取得すること' do
      expect(Github::Issue).to have_received(:assigned_by)
    end

    it '取得したデータをデータベースへ同期させること' do
      expect(Newspaper::Synchronizer).to have_received(:synchronize_issues)
    end

    it '取得したデータとユーザーの関係(Assign)を同期させること' do
      expect(Newspaper::Synchronizer).to have_received(:synchronize_assigns)
    end
  end
end
