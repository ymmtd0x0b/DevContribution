# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::Searchable, type: :model do
  include Destroyer::Searchable

  before do
    FactoryBot.create(:repository, id: 1)
  end

  let(:alice) { FactoryBot.create(:user, login: 'alice') }
  let(:bob) { FactoryBot.create(:user, login: 'bob') }

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
