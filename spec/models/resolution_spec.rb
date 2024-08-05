# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolution, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    context '引数に渡された PullRequest の issues_number 属性にデータがある場合' do
      it 'アソシエーションを新たに登録すること' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10)
        FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20)
        pull_request = FactoryBot.create(:pull_request, id: 300, number: 30)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 30, issues_number: [10, 20] })
          ]
          Resolution.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.pluck(:id) }.from([]).to([100, 200])
      end

      context '既存のアソシエーションに含まれる Issue が、引数に渡された PullRequest の issues_number 属性に無ければ' do
        it '対象アソシエーションを削除すること' do
          pull_request = FactoryBot.create(:pull_request, id: 300, number: 30)
          pull_request.issues << FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10)
          pull_request.issues << FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20)

          expect do
            pull_requests_collected_by_the_github_api = [
              GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 30, issues_number: [10] })
            ]
            Resolution.synchronize(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([100, 200]).to([100])
        end
      end
    end

    context '引数に渡された PullRequest の issues_number 属性にデータがない場合' do
      it 'その PullRequest の登録済みアソシエーションを全て削除すること' do
        pull_request = FactoryBot.create(:pull_request, id: 300, number: 30)
        pull_request.issues <<  FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, number: 10)
        pull_request.issues <<  FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, number: 20)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 30, issues_number: [] })
          ]
          Resolution.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.ids }.from([100, 200]).to([])
      end
    end
  end
end
