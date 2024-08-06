# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::CreatedIssue, type: :model do
  describe '#call' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    let(:created_issue_destroyer) { Destroyer::CreatedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '対象の Issue が「他のユーザーから参照されていない」場合' do
      it 'ユーザーが作成者である Issue を削除すること' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice)

        expect { created_issue_destroyer.call(alice) }.to change { alice.issues.count }.from(1).to(0)
                                                      .and change { Issue.count }.by(-1)
      end

      it 'ユーザーが作成者である Issue を削除すること (Issueに本人がアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) { |issue| issue.assignees << alice }

        expect { created_issue_destroyer.call(alice) }.to change { alice.issues.count }.from(1).to(0)
                                                      .and change { Issue.count }.by(-1)
      end

      it 'ユーザーが作成者である Issue を削除すること (関連する PullRequest に本人がアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.assignees << alice }
        end

        expect { created_issue_destroyer.call(alice) }.to change { alice.issues.count }.from(1).to(0)
                                                      .and change { Issue.count }.by(-1)
      end

      it 'ユーザーが作成者である Issue を削除すること (関連する PullRequest を本人がレビューしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
        end

        expect { created_issue_destroyer.call(alice) }.to change { alice.issues.count }.from(1).to(0)
                                                      .and change { Issue.count }.by(-1)
      end
    end

    context '対象の Issue が「他のユーザーから参照されている」場合' do
      it 'ユーザーが作成者である Issue を削除しないこと (Issue に他のユーザーがアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) { |issue| issue.assignees << bob }

        expect { created_issue_destroyer.call(alice) }.not_to change { alice.issues.count }.from(1)
      end

      it 'ユーザーが作成者である Issue を削除しないこと (関連する PullRequest に他のユーザーがアサインしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.assignees << bob }
        end

        expect { created_issue_destroyer.call(alice) }.not_to change { alice.issues.count }.from(1)
      end

      it 'ユーザーが作成者である Issue を削除しないこと (関連する PullRequest を他のユーザーがレビューしている)' do
        FactoryBot.create(:issue, :with_repository, repository_id: 1, user: alice) do |issue|
          issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << bob }
        end

        expect { created_issue_destroyer.call(alice) }.not_to change { alice.issues.count }.from(1)
      end
    end
  end
end
