# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedIssue, type: :model do
  describe '#call' do
    let(:assigned_issue_destroyer) { Destroyer::AssignedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがアサインしている Issue 内、「他のユーザーが参照していないもの」は「全て削除する」こと' do
      FactoryBot.create(:issue, title: 'Issue の作成者がデータベース上に存在しない') do |issue|
        issue.assigns.create!(user: alice)
      end

      FactoryBot.create(:issue, title: 'Issue の作成者がアリス本人', user: alice) do |issue|
        issue.assigns.create!(user: alice)
      end

      FactoryBot.create(:issue, title: '関連する PullRequest にアリスがアサインしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: '関連する PullRequest をアリスがレビューしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      expect { assigned_issue_destroyer.call(alice) }.to change { alice.assigned_issues.count }.from(4).to(0)
                                                     .and change { Issue.count }.by(-4)
    end

    it 'ユーザーがアサインしている Issue 内、「他のユーザーが参照してるもの」は「削除しない」こと' do
      FactoryBot.create(:issue, title: '作成者のボブがデータベース上に存在する', user: bob) do |issue|
        issue.assigns.create!(user: alice)
      end

      FactoryBot.create(:issue, title: 'Issue にボブもアサインしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.assigns.create!(user: bob)
      end

      FactoryBot.create(:issue, title: '関連する PullRequest にボブがアサインしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: bob) })
      end

      FactoryBot.create(:issue, title: '関連する PullRequest をボブがレビューしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: bob) })
      end

      expect { assigned_issue_destroyer.call(alice) }.not_to change { alice.assigned_issues.count }.from(4)
    end
  end
end
