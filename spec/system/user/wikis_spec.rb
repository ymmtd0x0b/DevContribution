# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Wikis', type: :system do
  before do
    FactoryBot.create(:repository, id: 123, name: 'test/repository')
  end

  scenario 'ユーザーが作成した Wiki を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:wiki, title: '議事録01', user: alice)
    FactoryBot.create(:wiki, title: '議事録02', user: alice)
    FactoryBot.create(:wiki, title: '議事録03', user: alice)

    login_as alice
    visit users_wikis_path(alice.login)

    expect(page).to have_link '議事録01'
    expect(page).to have_link '議事録02'
    expect(page).to have_link '議事録03'
  end

  context 'ゲストとしてアクセスした場合' do
    scenario 'トップページへリダイレクトされる' do
      visit users_wikis_path('alice')
      expect(page).to have_content 'ログインしてください'
      expect(page).to have_current_path '/'
    end
  end
end
