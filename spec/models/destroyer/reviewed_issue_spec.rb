# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::ReviewedIssue, type: :model do
  describe '#call' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    let(:reviewed_issue_destroyer) { Destroyer::ReviewedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '対象の Issue が「他のユーザーから参照されていない」場合' do
      it 'ユーザーがレビューしている Issue を削除すること (Issue の作成者がデータベース上に存在しない)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { reviewed_issue_destroyer.call(alice) }.to change { alice.reviewed_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがレビューしている Issue を削除すること (本人が Issue の作成者である)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { reviewed_issue_destroyer.call(alice) }.to change { alice.reviewed_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがレビューしている Issue を削除すること (本人のみ Issue にアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.assignees << alice
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { reviewed_issue_destroyer.call(alice) }.to change { alice.reviewed_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end

      it 'ユーザーがレビューしている Issue を削除すること (本人のみ PR にアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
            pr.reviewers << alice
            pr.assignees << alice
          end
        end

        expect { reviewed_issue_destroyer.call(alice) }.to change { alice.reviewed_issues.count }.from(1).to(0)
                                                       .and change { Issue.count }.by(-1)
      end
    end

    context '対象の Issue が「他のユーザーから参照されている」場合' do
      it 'ユーザーがレビューしている Issue を削除しないこと (他のユーザーが Issue の作成者である)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: bob) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { reviewed_issue_destroyer.call(alice) }.not_to change { alice.reviewed_issues.count }.from(1)
      end

      it 'ユーザーがレビューしている Issue を削除しないこと (他のユーザーが Issue にアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.assignees << bob
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { reviewed_issue_destroyer.call(alice) }.not_to change { alice.reviewed_issues.count }.from(1)
      end

      it 'ユーザーがレビューしている Issue を削除しないこと (他のユーザーも PR をレビューしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
            pr.reviewers << alice
            pr.reviewers << bob
          end
        end

        expect { reviewed_issue_destroyer.call(alice) }.not_to change { alice.reviewed_issues.count }.from(1)
      end

      it 'ユーザーがレビューしている Issue を削除しないこと (他のユーザーが PR にアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
            pr.reviewers << alice
            pr.assignees << bob
          end
        end

        expect { reviewed_issue_destroyer.call(alice) }.not_to change { alice.reviewed_issues.count }.from(1)
      end
    end
  end
end
