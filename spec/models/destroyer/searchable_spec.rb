# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::Searchable, type: :model do
  include Destroyer::Searchable

  let(:alice) { FactoryBot.create(:user, login: 'alice') }
  let(:bob) { FactoryBot.create(:user, login: 'bob') }

  describe 'filter_issues_assigned_by_other_users_from' do
    it '引数に渡した Issue ID の内、引数で指定したユーザー以外がアサインしているのもを返すこと' do
      FactoryBot.create(:issue, id: 100) do |issue|
        issue.assigns.create!(user: alice)
      end
      FactoryBot.create(:issue, id: 200) do |issue|
        issue.assigns.create!(user: alice)
        issue.assigns.create!(user: bob)
      end

      actual = filter_issues_assigned_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_referring_pull_requests_assigned_by_other_users_from' do
    it '引数に渡した Issue ID の内、関連する PullRequest に引数で指定したユーザー以外がアサインしているのもを返すこと' do
      FactoryBot.create(:issue, id: 100) do |issue|
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: alice) }
        issue.resolutions.create!(pull_request:)
      end
      FactoryBot.create(:issue, id: 200) do |issue|
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: bob) }
        issue.resolutions.create!(pull_request:)
      end

      actual = filter_issues_referring_pull_requests_assigned_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_referring_pull_requests_reviewed_by_other_users_from' do
    it '引数に渡した Issue ID の内、関連する PullRequest に引数で指定したユーザー以外がレビューしているのもを返すこと' do
      FactoryBot.create(:issue, id: 100) do |issue|
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: alice) }
        issue.resolutions.create!(pull_request:)
      end
      FactoryBot.create(:issue, id: 200) do |issue|
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.reviews.create!(user: bob) }
        issue.resolutions.create!(pull_request:)
      end

      actual = filter_issues_referring_pull_requests_reviewed_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_created_by_other_users_that_exist_in_database_from' do
    it '引数に渡した Issue ID の内、引数で指定されたユーザー以外の作成者がデータベースに存在するものを返すこと' do
      FactoryBot.create(:issue, id: 100, user: alice)
      FactoryBot.create(:issue, id: 200, user: bob)
      FactoryBot.create(:issue, id: 300, user_id: 0) # 作成者がデータベース上に存在しない

      actual = filter_issues_created_by_other_users_that_exist_in_database_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_pull_requests_assigned_by_other_users_from' do
    it '引数に渡した PullRequest ID の内、引数で指定されたユーザー以外がアサインしているものを返すこと' do
      FactoryBot.create(:pull_request, id: 100) { |pr| pr.assigns.create!(user: alice) }
      FactoryBot.create(:pull_request, id: 200) { |pr| pr.assigns.create!(user: bob) }

      actual = filter_pull_requests_assigned_by_other_users_from(PullRequest.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_pull_requests_reviewed_by_other_users_from' do
    it '引数に渡した PullRequest ID の内、引数で指定されたユーザー以外がレビューしているものを返すこと' do
      FactoryBot.create(:pull_request, id: 100) { |pr| pr.reviews.create!(user: alice) }
      FactoryBot.create(:pull_request, id: 200) { |pr| pr.reviews.create!(user: bob) }

      actual = filter_pull_requests_reviewed_by_other_users_from(PullRequest.ids, alice.id)
      expect(actual).to eq [200]
    end
  end
end
