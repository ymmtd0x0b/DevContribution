# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::Searchable, type: :model do
  include Destroyer::Searchable

  before do
    FactoryBot.create(:repository, id: 1)
  end

  let(:alice) { FactoryBot.create(:user, login: 'alice') }
  let(:bob) { FactoryBot.create(:user, login: 'bob') }

  describe 'filter_issues_assigned_by_other_users_from' do
    it '引数に渡した Issue ID の内、引数で指定したユーザー以外がアサインしているものを返すこと' do
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100) { |issue| issue.assignees << alice }
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200) { |issue| issue.assignees << [alice, bob] }

      actual = filter_issues_assigned_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_referring_pull_requests_assigned_by_other_users_from' do
    it '引数に渡した Issue ID の内、関連する PullRequest に引数で指定したユーザー以外がアサインしているものを返すこと' do
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.assignees << alice }
      end
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.assignees << [alice, bob] }
      end

      actual = filter_issues_referring_pull_requests_assigned_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_referring_pull_requests_reviewed_by_other_users_from' do
    it '引数に渡した Issue ID の内、関連する PullRequest に引数で指定したユーザー以外がレビューしているものを返すこと' do
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }
      end
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << [alice, bob] }
      end

      actual = filter_issues_referring_pull_requests_reviewed_by_other_users_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_issues_created_by_other_users_that_exist_in_database_from' do
    it '引数に渡した Issue ID の内、引数で指定されたユーザー以外の作成者がデータベースに存在するものを返すこと' do
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100, user: alice)
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 200, user: bob)
      FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 300, user_id: 0) # 作成者がデータベース上に存在しない

      actual = filter_issues_created_by_other_users_that_exist_in_database_from(Issue.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_pull_requests_assigned_by_other_users_from' do
    it '引数に渡した PullRequest ID の内、引数で指定されたユーザー以外がアサインしているものを返すこと' do
      FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100) { |pr| pr.assignees << alice }
      FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200) { |pr| pr.assignees << [alice, bob] }

      actual = filter_pull_requests_assigned_by_other_users_from(PullRequest.ids, alice.id)
      expect(actual).to eq [200]
    end
  end

  describe 'filter_pull_requests_reviewed_by_other_users_from' do
    it '引数に渡した PullRequest ID の内、引数で指定されたユーザー以外がレビューしているものを返すこと' do
      FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 100) { |pr| pr.reviewers << alice }
      FactoryBot.create(:pull_request, :with_repository, repository_id: 1, id: 200) { |pr| pr.reviewers << [alice, bob] }

      actual = filter_pull_requests_reviewed_by_other_users_from(PullRequest.ids, alice.id)
      expect(actual).to eq [200]
    end
  end
end
