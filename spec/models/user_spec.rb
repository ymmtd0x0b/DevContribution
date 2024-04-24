# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'login, avatar_url があれば有効であること' do
    user = User.new(
      login: 'tester',
      avatar_url: 'https://example.com/12345.jpg'
    )

    expect(user).to be_valid
  end

  describe '.find_or_initialize_by_github_auth' do
    before do
      @user = User.create!(
        id: 1,
        login: 'tester',
        avatar_url: 'https://example.com/12345.jpg'
      )
    end

    context 'ハッシュに該当するユーザーがデータベースに存在する場合' do
      it 'そのユーザーのレコードを返すこと' do
        auth_hash = {
          uid: 1,
          extra: {
            raw_info: {
              login: 'tester',
              avatar_url: 'https://example.com/12345.jpg'
            }
          }
        }

        found_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(found_user).to eq @user
      end
    end

    context 'ハッシュに該当するユーザーがデータベースに存在しない場合' do
      it '新しいユーザーとしてインスタンスオブジェクトを返すこと' do
        auth_hash = {
          uid: 999,
          extra: {
            raw_info: {
              login: 'alice',
              avatar_url: 'https://example.com/alice_avatar.jpg'
            }
          }
        }

        found_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(found_user).not_to eq @user
        expect(found_user.new_record?).to eq true
      end
    end
  end

  describe '#issues' do
    context 'ユーザーが作成者である Issue があれば' do
      it '該当するレコードを返すこと' do
        alice = User.create!(
          login: 'alice',
          avatar_url: 'https://example.com/12345.jpg'
        )

        bob = User.create!(
          login: 'bob',
          avatar_url: 'https://example.com/12345.jpg'
        )

        repository = Repository.create!(
          name: 'SampleRepository',
          url: 'https://example.com/sample_repository',
          avatar_url: 'https://example.com/12345.jpg'
        )

        issue_for_add_feature = Issue.create!(
          repository_id: repository.id,
          user_id: alice.id,
          title: '新機能の追加',
          number: 100
        )

        issue_for_bug_fix = Issue.create!(
          repository_id: repository.id,
          user_id: alice.id,
          title: 'バグの修正',
          number: 200
        )

        good_first_issue = Issue.create!(
          repository_id: repository.id,
          user_id: bob.id,
          title: '簡単なIssue',
          number: 300
        )

        expect(alice.issues).to include(issue_for_add_feature, issue_for_bug_fix)
        expect(alice.issues).not_to include good_first_issue
      end
    end

    context 'ユーザーが作成者である Issue がなければ' do
      it '空の Array を返すこと' do
        carol = User.create!(
          login: 'carol',
          avatar_url: 'https://example.com/12345.jpg'
        )

        expect(carol.issues).to eq []
      end
    end
  end
end
