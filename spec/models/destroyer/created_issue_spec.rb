# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::CreatedIssue, type: :model do
  describe '#call' do
    let(:created_issue_destroyer) { Destroyer::CreatedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーが作成者である Issue 内、「他のユーザーが参照していないもの」は「全て削除する」こと' do
      FactoryBot.create(:issue, user: alice, title: 'アリスが作成者である Issue')

      FactoryBot.create(:issue, user: alice, title: 'Issue にアリスがアサインしている') do |issue|
        issue.assigns.create!(user: alice)
      end

      FactoryBot.create(:issue, user: alice, title: '関連する PullRequest にアリスがアサインしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: alice) })
      end

      FactoryBot.create(:issue, user: alice, title: '関連する PullRequest をアリスがレビューしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      expect { created_issue_destroyer.call(alice) }.to change { alice.issues.count }.from(4).to(0)
                                                    .and change { Issue.count }.by(-4)
    end

    it 'ユーザーが作成者である Issue 内、「他のユーザーが参照しているもの」は「削除しない」こと' do
      FactoryBot.create(:issue, user: alice, title: 'Issue にボブがアサインしている') do |issue|
        issue.assigns.create!(user: bob)
      end

      FactoryBot.create(:issue, user: alice, title: '関連する PullRequest にボブがアサインしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: bob) })
      end

      FactoryBot.create(:issue, user: alice, title: '関連する PullRequest をボブがレビューしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: bob) })
      end

      expect { created_issue_destroyer.call(alice) }.not_to change { alice.issues.count }.from(3)
    end
  end
end
