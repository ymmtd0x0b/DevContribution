# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolution, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    context '引数に渡された PullRequest の issues_number 属性に、既存のアソシエーションに登録していない Issue がある場合' do
      it '対象の Issue とのアソシエーションを登録すること' do
        pull_request = FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 300, number: 30)
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10) { |issue| issue.pull_requests << pull_request }
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 30, issues_number: [10, 20] })
          ]
          Resolution.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.ids }.from([100]).to([100, 200])
      end
    end

    context '引数に渡された PullRequest の issues_number 属性に、既存のアソシエーションに登録している Issue がない場合' do
      it '対象の Issue とのアソシエーションを削除すること' do
        pull_request = FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 300, number: 30)
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10) { |issue| issue.pull_requests << pull_request }
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20) { |issue| issue.pull_requests << pull_request }

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 30, issues_number: [10] })
          ]
          Resolution.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.ids }.from([100, 200]).to([100])
      end
    end
  end
end
