# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効なファクトリを持つこと' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  describe '.find_or_initialize_by_github_auth' do
    before do
      @alice = FactoryBot.create(:user, id: 123, login: 'alice')
    end

    context 'ハッシュに該当するユーザーがデータベースに存在する場合' do
      it 'そのユーザーのレコードを返すこと' do
        auth_hash = OmniAuth::AuthHash.new(uid: 123, info: { nickname: 'alice' })

        found_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(found_user).to eq @alice
      end
    end

    context 'ハッシュに該当するユーザーがデータベースに存在しない場合' do
      it '新しいユーザーとしてインスタンスオブジェクトを返すこと' do
        auth_hash = OmniAuth::AuthHash.new(uid: 456, info: { nickname: 'bob' })

        initialized_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(initialized_user).not_to eq @alice
        expect(initialized_user.new_record?).to eq true
      end
    end
  end

  describe '#assigned_pull_requests.not_referenced_by_other_users' do
    context 'ユーザーがアサインしている PullRequest の内' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest にアサイン)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.assignees << taro }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) { |pr| pr.assignees << jiro }

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest をレビュー)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.assignees << taro
          pr.reviewers << taro
        end
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) do |pr|
          pr.assignees << taro
          pr.reviewers << jiro
        end

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end
  end

  describe '#reviewed_pull_requests.not_referenced_by_other_users' do
    context 'ユーザーがレビューしている PullRequest の内' do
      before do
        FactoryBot.create(:repository, id: 123)
      end

      let(:taro) { FactoryBot.create(:user, id: 456, login: 'taro') }
      let(:jiro) { FactoryBot.create(:user, id: 789, login: 'jiro') }

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest にアサイン)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.reviewers << taro
          pr.assignees << taro
        end
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) do |pr|
          pr.reviewers << taro
          pr.assignees << jiro
        end

        actual = taro.reviewed_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it '他のユーザーが参照していない PullRequest を返すこと (PullRequest をレビュー)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.reviewers << taro }
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 200) { |pr| pr.reviewers << jiro }

        actual = taro.reviewed_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end
  end
end
