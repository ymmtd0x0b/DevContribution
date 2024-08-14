# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::IssuesAssociationExtension do
  describe '#not_referenced_by_other_users' do
    context 'ユーザーがアサインしている Issue の場合 (has_many :assigned_issues)' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない Issue を返すこと (Issue にアサイン)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) { |issue| issue.assignees << taro }
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) { |issue| issue.assignees << [taro, jiro] }

        actual = taro.assigned_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue の作成者：データベース上に存在しないユーザーの場合は参照していないと見做す)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100, user: taro) { |issue| issue.assignees << taro }
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200, user: jiro) { |issue| issue.assignees << taro }
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 300, user_id: 0) { |issue| issue.assignees << taro } # 作成者がデータベース上に存在しない

        actual = taro.assigned_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100, 300]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue に関連する PullRequest にアサイン)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
          issue.assignees << taro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.assignees << taro }
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
          issue.assignees << taro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.assignees << jiro }
        end

        actual = taro.assigned_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue に関連する PullRequest をレビュー)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
          issue.assignees << taro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
          issue.assignees << taro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << jiro }
        end

        actual = taro.assigned_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end

    context 'ユーザーがレビューしている Issue の場合 (has_many: reviewed_issues)' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない Issue を返すこと (Issue にアサイン)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
          issue.assignees << taro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
          issue.assignees << jiro
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end

        actual = taro.reviewed_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue の作成者：データベース上に存在しないユーザーの場合は参照していないと見做す)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100, user: taro) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200, user: jiro) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 300, user_id: 0) do |issue| # 作成者がデータベース上に存在しない
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
        end

        actual = taro.reviewed_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100, 300]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue に関連する PullRequest にアサイン)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) do |pr|
            pr.assignees << taro
            pr.reviewers << taro
          end
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) do |pr|
            pr.assignees << jiro
            pr.reviewers << taro
          end
        end

        actual = taro.reviewed_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない Issue を返すこと (Issue に関連する PullRequest をレビュー)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) do |pr|
            pr.reviewers << taro
          end
        end
        FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) do |pr|
            pr.reviewers << [taro, jiro]
          end
        end

        actual = taro.reviewed_issues.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end
  end
end
