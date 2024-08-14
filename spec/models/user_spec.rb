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
end
