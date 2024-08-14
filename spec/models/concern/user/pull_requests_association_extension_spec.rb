# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::PullRequestsAssociationExtension do
  describe '#assigned_pull_requests.not_referenced_by_other_users' do
    context 'ユーザーがアサインしている PullRequest の場合 (has_may :assigned_pull_requests)' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest にアサイン)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.assignees << taro }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) { |pr| pr.assignees << jiro }

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest をレビュー)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.assignees << taro
          pr.reviewers << taro
        end
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) do |pr|
          pr.assignees << taro
          pr.reviewers << jiro
        end

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end

    context 'ユーザーがレビューしている PullRequest の場合 (has_may :reviewed_pull_requests)' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest にアサイン)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.reviewers << taro
          pr.assignees << taro
        end
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) do |pr|
          pr.reviewers << taro
          pr.assignees << jiro
        end

        actual = taro.reviewed_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest をレビュー)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.reviewers << taro }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) { |pr| pr.reviewers << jiro }

        actual = taro.reviewed_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end
  end
end
