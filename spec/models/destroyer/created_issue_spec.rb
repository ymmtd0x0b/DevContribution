# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::CreatedIssue, type: :model do
  describe '#call' do
    let(:created_issue_destroyer) { Destroyer::CreatedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーが作成者である Issue 内、「他のユーザーが参照していないもの」は「削除する」こと' do
      FactoryBot.create(:issue, id: 100, user: alice, title: 'アリスが作成者である Issue')

      FactoryBot.create(:issue, id: 200, user: alice, title: 'アリスが作成者である Issue + アリスがアサインしている') do |issue|
        issue.assigns.create!(user: alice)
      end

      FactoryBot.create(:issue, id: 300, user: alice, title: 'アリスが作成者である Issue + 関連する PR にアリスがアサインしている') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.assigns.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 400, user: alice, title: 'アリスが作成者である Issue + 関連する PR をアリスがレビューしている') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: alice)
          pull_request.resolutions.create!(issue:)
        end
      end

      expect { created_issue_destroyer.call(alice) }.to change { alice.issues.ids }.from([100, 200, 300, 400]).to([])
                                                    .and change { Issue.count }.by(-4)
    end

    it 'ユーザーが作成者である Issue 内、「他のユーザーが参照しているもの」は「削除しない」こと' do
      FactoryBot.create(:issue, id: 100, user: alice, title: 'アリスが作成者である Issue + ボブがアサインしている') do |issue|
        issue.assigns.create!(user: bob)
      end

      FactoryBot.create(:issue, id: 200, user: alice, title: 'アリスが作成者である Issue + 関連する PR にボブがアサインしている') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.assigns.create!(user: bob)
          pull_request.resolutions.create!(issue:)
        end
      end

      FactoryBot.create(:issue, id: 300, user: alice, title: 'アリスが作成者である Issue + 関連する PR をボブがレビューしている') do |issue|
        FactoryBot.create(:pull_request) do |pull_request|
          pull_request.reviews.create!(user: bob)
          pull_request.resolutions.create!(issue:)
        end
      end

      expect { created_issue_destroyer.call(alice) }.to not_change { alice.issues.ids }.from([100, 200, 300])
                                                    .and not_change { Issue.count }.from(3)
    end
  end
end
