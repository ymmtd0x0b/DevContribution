# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolution, type: :model do
  describe '.synchronize' do
    context '引数に渡された PullRequest の issues_number 属性にデータがある場合' do
      context '一致する Issue がデータベースに存在すれば' do
        it 'アソシエーションを新たに登録すること' do
          FactoryBot.create(:issue, id: 100, number: 100)
          FactoryBot.create(:issue, id: 200, number: 200)
          pull_request = FactoryBot.create(:pull_request, id: 300, number: 300)

          expect do
            pull_requests_collected_by_the_github_api = [
              Github::PullRequest.new(repository_id: 1, pull_request: { id: 300, number: 300, issues_number: [100, 200] })
            ]
            Resolution.synchronize(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([]).to([100, 200])
        end
      end

      context '一致する Issue がデータベースに存在しなければ' do
        it 'アソシエーションを登録しない(できない)こと' do
          FactoryBot.create(:issue, id: 100, number: 100)
          pull_request = FactoryBot.create(:pull_request, id: 200, number: 200)

          expect do
            pull_requests_collected_by_the_github_api = [
              Github::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 200, issues_number: [100, 999] })
            ]
            Resolution.synchronize(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([]).to([100])
        end
      end

      context '既存のアソシエーションに含まれる Issue が、引数に渡された PullRequest の issues_number 属性に無ければ' do
        it '対象アソシエーションを削除すること' do
          pull_request = FactoryBot.create(:pull_request, id: 300, number: 300) do |created_pull_request|
            created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 100, number: 100))
            created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 200, number: 200))
          end

          expect do
            pull_requests_collected_by_the_github_api = [
              Github::PullRequest.new(repository_id: 123, pull_request: { id: 300, number: 300, issues_number: [100] })
            ]
            Resolution.synchronize(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([100, 200]).to([100])
        end
      end
    end

    context '引数に渡された PullRequest の issues_number 属性にデータがない場合' do
      it 'その PullRequest の登録済みアソシエーションを全て削除すること' do
        pull_request = FactoryBot.create(:pull_request, id: 100, number: 100) do |created_pull_request|
          created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 123))
          created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 456))
        end

        expect do
          pull_requests_collected_by_the_github_api = [
            Github::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] })
          ]
          Resolution.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.ids }.from([123, 456]).to([])
      end
    end
  end
end
