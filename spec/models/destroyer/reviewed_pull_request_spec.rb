# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::ReviewedPullRequest, type: :model do
  describe '#call' do
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがレビューしている PullRequest の内、「他のユーザーが参照していないもの」は「削除する」こと' do
      FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) }

      FactoryBot.create(:pull_request) do |pr| # ユーザー本人がアサインしている
        pr.reviews.create!(user: alice)
        pr.assigns.create!(user: alice)
      end

      expect { Destroyer::ReviewedPullRequest.new.call(alice) }.to change { alice.reviewed_pull_requests.count }.from(2).to(0)
                                                               .and change { PullRequest.count }.by(-2)
    end

    it 'ユーザーがレビューしている PullRequest の内、「他のユーザーが参照しているもの」は「削除しない」こと' do
      FactoryBot.create(:pull_request) do |pr| # 他のユーザーがアサインしている
        pr.reviews.create!(user: alice)
        pr.assigns.create!(user: bob)
      end

      FactoryBot.create(:pull_request) do |pr| # 他のユーザーがレビューしている
        pr.reviews.create!(user: alice)
        pr.reviews.create!(user: bob)
      end

      expect { Destroyer::ReviewedPullRequest.new.call(alice) }.not_to change { alice.reviewed_pull_requests.count }.from(2)
    end
  end
end
