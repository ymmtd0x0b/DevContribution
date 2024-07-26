# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login And Logout', type: :system do
  before do
    FactoryBot.create(:repository, id: 123)
    FactoryBot.create(:user, id: 456, login: 'alice')
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github', uid: 456, info: { nickname: 'alice', name: '', image: '' } })
  end

  scenario 'ログインに成功すること' do
    visit root_path
    click_button 'ログイン'

    expect(page).to have_current_path '/alice/issues?association=assigned'
    expect(page).to have_content 'ログインしました'
  end

  context 'ユーザーとして、アカウント登録ボタンをクリックした場合' do
    scenario 'ログインに成功すること' do
      visit root_path
      click_button 'GitHubアカントで登録'

      expect(page).to have_current_path '/alice/issues?association=assigned'
      expect(page).to have_content 'ログインしました'
    end
  end

  scenario 'ログアウトに成功すること' do
    visit root_path
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました'

    using_wait_time(5) do # フラッシュメッセージとログアウトボタンが重なるので、メッセージが閉じるまで待つ
      click_button 'alice'
      click_link 'ログアウト'
    end

    expect(page).to have_current_path '/'
    expect(page).to have_content 'ログアウトしました'
  end
end
