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

  describe '#assigned_issues.too_other_user' do
    it 'ユーザーがアサインしている Issue の内、他のユーザーも参照している Issue を選別して返すこと' do
      FactoryBot.create(:repository, id: 123)
      taro = FactoryBot.create(:user, id: 456, login: 'taro')
      jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) { |issue| issue.assignees << taro }
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) { |issue| issue.assignees << [taro, jiro] }

      actual = taro.assigned_issues.too_other_user.ids
      expect(actual).to eq [200]
    end
  end

  describe '#assigned_issues.by_other_author' do
    it 'ユーザーがアサインしている Issue の内、データベースに存在する他のユーザーが作成者である Issue に絞って返すこと' do
      FactoryBot.create(:repository, id: 123)
      taro = FactoryBot.create(:user, id: 456, login: 'taro')
      jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100, user: taro) { |issue| issue.assignees << taro }
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200, user: jiro) { |issue| issue.assignees << taro }
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 300, user_id: 0) { |issue| issue.assignees << taro } # 作成者がデータベース上に存在しない

      actual = taro.assigned_issues.by_other_author.ids
      expect(actual).to eq [200]
    end
  end

  describe '#assigned_issues.pull_requests.assigned_other_user' do
    it 'ユーザーがアサインしている Issue の内、関連する PullRequest に他のユーザーがアサインしている Issue に絞って返すこと' do
      FactoryBot.create(:repository, id: 123)
      taro = FactoryBot.create(:user, id: 456, login: 'taro')
      jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.assignees << taro }
      end
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.assignees << [taro, jiro] }
      end

      actual = taro.assigned_issues.resolved_pull_requests_assigned_other_user.ids
      expect(actual).to eq [200]
    end
  end

  describe '#assigned_issues.pull_requests.assigned_other_user' do
    it 'ユーザーがアサインしている Issue の内、関連する PullRequest に他のユーザーがレビューしている Issue に絞って返すこと' do
      FactoryBot.create(:repository, id: 123)
      taro = FactoryBot.create(:user, id: 456, login: 'taro')
      jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 100) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << taro }
      end
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 200) do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << [taro, jiro] }
      end

      actual = taro.assigned_issues.resolved_pull_requests_reviewed_other_user.ids
      expect(actual).to eq [200]
    end
  end

  describe '#assigned_pull_requests.not_referenced_by_other_users' do
    before do
      FactoryBot.create(:repository, id: 123)
    end

    context '他のユーザーが参照(アサインorレビュー)していない場合' do
      it 'ユーザーがアサインしている PullRequest を返すこと' do
        taro = FactoryBot.create(:user, id: 456, login: 'taro')
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.assignees << taro }

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end

      it 'ユーザーがアサインしている PullRequest を返すこと(本人が PullRequest をレビューしている)' do
        taro = FactoryBot.create(:user, id: 456, login: 'taro')
        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.assignees << taro
          pr.reviewers << taro
        end

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to eq [100]
      end
    end

    context '他のユーザーが参照(アサインorレビュー)している場合' do
      it '空の Array を返すこと(他のユーザーが PullRequest をアサインしている)' do
        taro = FactoryBot.create(:user, id: 456, login: 'taro')
        jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) { |pr| pr.assignees << [taro, jiro] }

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to be_empty
      end

      it '空の Array を返すこと(他のユーザーが PullRequest をレビューしている)' do
        taro = FactoryBot.create(:user, id: 456, login: 'taro')
        jiro = FactoryBot.create(:user, id: 789, login: 'jiro')

        FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 100) do |pr|
          pr.assignees << taro
          pr.reviewers << jiro
        end

        actual = taro.assigned_pull_requests.not_referenced_by_other_users.ids
        expect(actual).to be_empty
      end
    end
  end
end
