# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当しない Issue が存在する場合' do
      it '対象の Issue とユーザーのアソシエーションを登録する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10) { |issue| issue.assignees << user }
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20)

        expect do
          issues_collected_by_the_github_api = [
            GitHub::Issue.new(repository_id: 1, issue: { id: 100, user_id: 1, title: 'issue#100', number: 10, labels_id: [] }),
            GitHub::Issue.new(repository_id: 1, issue: { id: 200, user_id: 1, title: 'issue#200', number: 20, labels_id: [] })
          ]
          Assign.synchronize('Issue', issues_collected_by_the_github_api, user)
        end.to change { user.assigned_issues.ids }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当する Issue が存在しない場合' do
      it '対象の Issue とユーザーのアソシエーションを削除する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10) { |issue| issue.assignees << user }
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20) { |issue| issue.assignees << user }

        expect do
          issues_collected_by_the_github_api = [
            GitHub::Issue.new(repository_id: 1, issue: { id: 100, user_id: 1, title: 'issue#100', number: 10, labels_id: [] })
          ]
          Assign.synchronize('Issue', issues_collected_by_the_github_api, user)
        end.to change { user.assigned_issues.ids }.from([100, 200]).to([100])
      end
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当しない PullRequest が存在する場合' do
      it '対象の PullRequest とユーザーのアソシエーションを登録する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100, number: 10) { |pr| pr.assignees << user }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200, number: 20)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 10, issues_number: [] }),
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 20, issues_number: [] })
          ]
          Assign.synchronize('PullRequest', pull_requests_collected_by_the_github_api, user)
        end.to change { user.assigned_pull_requests.ids }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に、既存のアソシエーションに該当する PullRequest が存在しない場合' do
      it '対象の PullRequest とユーザーのアソシエーションを削除する' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100, number: 10) { |pr| pr.assignees << user }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200, number: 20) { |pr| pr.assignees << user }

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 10, issues_number: [] })
          ]
          Assign.synchronize('PullRequest', pull_requests_collected_by_the_github_api, user)
        end.to change { user.assigned_pull_requests.ids }.from([100, 200]).to([100])
      end
    end
  end
end
