# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当しない PullRequest が存在する場合' do
      it '対象の PullRequest とユーザーのアソシエーションを登録する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100, number: 10) { |pr| pr.reviewers << user }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200, number: 20)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 10, issues_number: [] }),
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 20, issues_number: [] })
          ]
          Review.synchronize(pull_requests_collected_by_the_github_api, user)
        end.to change { user.reviewed_pull_requests.ids }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当する PullRequest が存在しない場合' do
      it '対象の PullRequest とユーザーのアソシエーションを削除する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100, number: 10) { |pr| pr.reviewers << user }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200, number: 20) { |pr| pr.reviewers << user }

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 10, issues_number: [] })
          ]
          Review.synchronize(pull_requests_collected_by_the_github_api, user)
        end.to change { user.reviewed_pull_requests.ids }.from([100, 200]).to([100])
      end
    end
  end
end
