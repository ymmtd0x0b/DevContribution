# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedIssue, type: :model do
  describe '#call' do
    before do
      FactoryBot.create(:repository, id: 123)
    end

    let(:assigned_issue_destroyer) { Destroyer::AssignedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '対象の Issue が「他のユーザーから参照されていない」場合' do
      it 'ユーザーがアサインしている Issue を削除すること (Issue の作成者がデータベース上に存在しない)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) { |issue| issue.assignees << alice }
        expect { assigned_issue_destroyer.call(alice) }.to change { alice.assigned_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがアサインしている Issue を削除すること (Issue の作成者がユーザー本人)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, user: alice) { |issue| issue.assignees << alice }
        expect { assigned_issue_destroyer.call(alice) }.to change { alice.assigned_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがアサインしている Issue を削除すること (Issue と関連した PullRequest にアリスがアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) do |issue|
          issue.assignees << alice
          issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.assignees << alice }
        end

        expect { assigned_issue_destroyer.call(alice) }.to change { alice.assigned_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがアサインしている Issue を削除すること (Issue と関連した PullRequest をアリスがレビューしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) do |issue|
          issue.assignees << alice
          issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.reviewers << alice }
        end

        expect { assigned_issue_destroyer.call(alice) }.to change { alice.assigned_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end
    end

    context '対象の Issue が「他のユーザーから参照されている」場合' do
      it 'ユーザーがアサインしている Issue は削除しないこと (作成者のボブがデータベース上に存在する)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123, user: bob) { |issue| issue.assignees << alice }
        expect { assigned_issue_destroyer.call(alice) }.not_to change { alice.assigned_issues.count }.from(1)
      end

      it 'ユーザーがアサインしている Issue は削除しないこと (Issue にボブがアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) { |issue| issue.assignees << [alice, bob] }
        expect { assigned_issue_destroyer.call(alice) }.not_to change { alice.assigned_issues.count }.from(1)
      end

      it 'ユーザーがアサインしている Issue は削除しないこと (Issue と関連した PullRequest にボブがアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) do |issue|
          issue.assignees << alice
          issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.assignees << bob }
        end

        expect { assigned_issue_destroyer.call(alice) }.not_to change { alice.assigned_issues.count }.from(1)
      end

      it 'ユーザーがアサインしている Issue は削除しないこと (Issue と関連した PullRequest をボブがレビューしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 123) do |issue|
          issue.assignees << alice
          issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.reviewers << bob }
        end

        expect { assigned_issue_destroyer.call(alice) }.not_to change { alice.assigned_issues.count }.from(1)
      end
    end
  end
end
