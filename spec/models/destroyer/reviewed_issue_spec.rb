# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::ReviewedIssue, type: :model do
  describe '#call' do
    let(:reviewed_issue_destroyer) { Destroyer::ReviewedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがレビューしている Issue 内、他のユーザーが参照していないものは削除すること' do
      FactoryBot.create(:issue, id: 100, title: 'アリスがレビューしている Issue') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 200, title: 'アリスがアサイン＆レビューしている Issue') do |issue|
        issue.assigns.create!(user: alice)
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 300, user: alice, title: 'アリスがレビューしている Issue (作成者がアリス)') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      expect { reviewed_issue_destroyer.call(alice) }.to change { Issue.pluck(:id) }.from([100, 200, 300]).to([])
    end

    it 'ユーザーがレビューしている Issue 内、他のユーザーが参照してるものは削除しないこと' do
      FactoryBot.create(:issue, id: 100, title: 'ボブがアサインし、アリスがレビューしている Issue') do |issue|
        issue.assigns.create!(user: bob)
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 200, title: 'アリスとボブがレビューしている Issue') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.reviews.create!(user: bob)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 300, title: 'アリスがレビューしている Issue ( PR にボブがアサインしている)') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.assigns.create!(user: bob)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 400, user: bob, title: 'アリスがレビューしている Issue (作者のボブがデータベース上に存在する)') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      expect { reviewed_issue_destroyer.call(alice) }.not_to change { Issue.pluck(:id) }.from([100, 200, 300, 400])
    end
  end
end
