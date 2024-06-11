# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Newspaper::Synchronizer, type: :model do

  describe '.synchronize_resolutions' do
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
            Newspaper::Synchronizer.synchronize_resolutions(pull_requests_collected_by_the_github_api)
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
            Newspaper::Synchronizer.synchronize_resolutions(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([]).to([100])
        end
      end

      context '登録済みアソシエーション先の Issue が含まれて無ければ' do
        it '対象アソシエーションを削除すること' do
          pull_request = FactoryBot.create(:pull_request, id: 300, number: 300) do |created_pull_request|
            created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 100, number: 100))
            created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue, id: 200, number: 200))
          end

          expect do
            pull_requests_collected_by_the_github_api = [
              Github::PullRequest.new(repository_id: 123, pull_request: { id: 300, number: 300, issues_number: [100] })
            ]
            Newspaper::Synchronizer.synchronize_resolutions(pull_requests_collected_by_the_github_api)
          end.to change { pull_request.issues.pluck(:id) }.from([100, 200]).to([100])
        end
      end
    end

    context '引数に渡された PullRequest の issues_number 属性にデータがない場合' do
      it 'その PullRequest が持つ Issue とのアソシエーションを全て削除すること' do
        pull_request = FactoryBot.create(:pull_request, id: 100, number: 100) do |created_pull_request|
          created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue))
          created_pull_request.resolutions.create!(issue: FactoryBot.create(:issue))
        end

        expect do
          pull_requests_collected_by_the_github_api = [
            Github::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] })
          ]
          Newspaper::Synchronizer.synchronize_resolutions(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.issues.count }.from(2).to(0)
      end
    end
  end

  describe '.synchronize_reviews' do
    context '引数に渡されたデータの中に、既存のアソシエーションに該当しない PullRequest が存在する場合' do
      it '対象の PullRequest とユーザーのアソシエーションを登録する' do
        FactoryBot.create(:pull_request, id: 100)
        FactoryBot.create(:pull_request, id: 200)

        user = FactoryBot.create(:user) { |created_user| created_user.reviews.create!(pull_request_id: 100) }

        expect do
          pull_requests_collected_by_the_github_api = [
            Github::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] }),
            Github::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 200, issues_number: [] })
          ]
          Newspaper::Synchronizer.synchronize_reviews(pull_requests_collected_by_the_github_api, user)
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
            Github::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] })
          ]
          Newspaper::Synchronizer.synchronize_reviews(pull_requests_collected_by_the_github_api, user)
        end.to change { user.reviewed_pull_requests.pluck(:id) }.from([100, 200]).to([100])
      end
    end
  end
end
