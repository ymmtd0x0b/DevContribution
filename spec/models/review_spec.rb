# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '.synchronize' do
    context '引数に渡されたデータの中に、既存のアソシエーションに該当しない PullRequest が存在する場合' do
      it '対象の PullRequest とユーザーのアソシエーションを登録する' do
        FactoryBot.create(:pull_request, id: 100)
        FactoryBot.create(:pull_request, id: 200)

        user = FactoryBot.create(:user) { |created_user| created_user.reviews.create!(pull_request_id: 100) }

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] }),
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 200, issues_number: [] })
          ]
          Review.synchronize(pull_requests_collected_by_the_github_api, user)
        end.to change { user.reviewed_pull_requests.pluck(:id) }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当する PullRequest が存在しない場合' do
      it '対象の PullRequest とユーザーのアソシエーションを削除する' do
        FactoryBot.create(:pull_request, id: 100)
        FactoryBot.create(:pull_request, id: 200)

        user = FactoryBot.create(:user) do |created_user|
          created_user.reviews.create!(pull_request_id: 100)
          created_user.reviews.create!(pull_request_id: 200)
        end

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] })
          ]
          Review.synchronize(pull_requests_collected_by_the_github_api, user)
        end.to change { user.reviewed_pull_requests.pluck(:id) }.from([100, 200]).to([100])
      end
    end
  end
end
