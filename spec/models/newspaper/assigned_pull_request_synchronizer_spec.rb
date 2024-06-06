# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Newspaper::AssignedPullRequestSynchronizer, type: :model do
  describe '#call' do
    before do
      allow(Github::PullRequest).to receive(:assigned_by)
      allow(Newspaper::Synchronizer).to receive(:synchronize_pull_requests)
      allow(Newspaper::Synchronizer).to receive(:synchronize_assigns)
      allow(Newspaper::Synchronizer).to receive(:synchronize_resolutions)

      repository = FactoryBot.create(:repository)
      user = FactoryBot.create(:user)
      Newspaper::AssignedPullRequestSynchronizer.new.call({ repository:, user: })
    end

    it 'GitHubから対象の PullRequest を取得すること' do
      expect(Github::PullRequest).to have_received(:assigned_by)
    end

    it '取得したデータをデータベースへ同期させること' do
      expect(Newspaper::Synchronizer).to have_received(:synchronize_pull_requests)
    end

    it '取得したデータとユーザーの関係(Assign)を同期させること' do
      expect(Newspaper::Synchronizer).to have_received(:synchronize_assigns)
    end

    it '取得したデータと Issue の関係(Resolution)を同期させること' do
      expect(Newspaper::Synchronizer).to have_received(:synchronize_resolutions)
    end
  end
end
