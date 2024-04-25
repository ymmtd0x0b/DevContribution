# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効なファクトリを持つこと' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'login があれば有効であること' do
    user = User.new(login: 'valid_user')
    expect(user).to be_valid
  end

  describe '.find_or_initialize_by_github_auth' do
    before do
      @alice = FactoryBot.create(:user, id: 1, login: 'alice', avatar_url: 'https://example.com/12345.jpg')
    end

    context 'ハッシュに該当するユーザーがデータベースに存在する場合' do
      it 'そのユーザーのレコードを返すこと' do
        auth_hash = OmniAuth::AuthHash.new(uid: 1, info: { nickname: 'alice', image: 'https://example.com/12345.jpg' })

        found_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(@alice.persisted?).to eq true
        expect(found_user).to eq @alice
      end
    end

    context 'ハッシュに該当するユーザーがデータベースに存在しない場合' do
      it '新しいユーザーとしてインスタンスオブジェクトを返すこと' do
        auth_hash = OmniAuth::AuthHash.new(uid: 2, info: { nickname: 'bob', image: 'https://example.com/54321.jpg' })

        initialized_user = User.find_or_initialize_by_github_auth(auth_hash)
        expect(initialized_user).not_to eq @alice
        expect(initialized_user.new_record?).to eq true
      end
    end
  end

  describe '#issues' do
    before do
      @alice = FactoryBot.create(:user, login: 'alice')
      @bob = FactoryBot.create(:user, login: 'bob')

      @issue1_created_by_alice = FactoryBot.create(:issue, title: 'alice が作成した Issue', user: @alice)
      @issue2_created_by_alice = FactoryBot.create(:issue, title: 'alice が作成した Issue', user: @alice)
      @issue3_created_by_bob = FactoryBot.create(:issue, title: 'bob が作成した Issue', user: @bob)
    end

    context 'ユーザーが作成者である Issue があれば' do
      it '該当するレコードを返すこと' do
        expect(@alice.issues).to include(@issue1_created_by_alice, @issue2_created_by_alice)
        expect(@alice.issues).not_to include(@issue3_created_by_bob)

        expect(@bob.issues).to include(@issue3_created_by_bob)
        expect(@bob.issues).not_to include(@issue1_created_by_alice, @issue2_created_by_alice)
      end
    end

    context 'ユーザーが作成者である Issue がなければ' do
      it '空の Array を返すこと' do
        carol = FactoryBot.create(:user, login: 'carol')
        expect(carol.issues).to eq []
      end
    end
  end
end
