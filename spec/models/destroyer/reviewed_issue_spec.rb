# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::ReviewedIssue, type: :model do
  describe '#call' do
    let(:reviewed_issue_destroyer) { Destroyer::ReviewedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがレビューしている Issue 内、「他のユーザーが参照していないもの」は「削除する」こと' do
      FactoryBot.create(:issue, title: 'Issue の作成者がデータベース上に存在しない') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'Issue の作成者がアリス本人', user: alice) do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'Issue にアリスがアサインしている') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: '関連する PullRequest にアリスがアサインしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) do |pr|
          pr.reviews.create!(user: alice)
          pr.assigns.create!(user: alice)
        end)
      end

      expect { reviewed_issue_destroyer.call(alice) }.to change { alice.reviewed_issues.count }.from(4).to(0)
                                                     .and change { Issue.count }.by(-4)
    end

    it 'ユーザーがレビューしている Issue 内、「他のユーザーが参照してるもの」は「削除しない」こと' do
      FactoryBot.create(:issue, title: 'Issue の作成者であるボブがデータベース上に存在する', user: bob) do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'Issue にボブがアサインしている') do |issue|
        issue.assigns.create!(user: bob)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'ボブもレビューしている') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) do |pr|
          pr.reviews.create!(user: alice)
          pr.reviews.create!(user: bob)
        end)
      end

      FactoryBot.create(:issue, title: '関連する PullRequest にボブがアサインしている)') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request) do |pr|
          pr.reviews.create!(user: alice)
          pr.assigns.create!(user: bob)
        end)
      end

      expect { reviewed_issue_destroyer.call(alice) }.not_to change { alice.reviewed_issues.count }.from(4)
    end
  end
end
