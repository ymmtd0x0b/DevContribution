# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login And Logout', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('123')

    FactoryBot.create(:repository, id: 123)
    FactoryBot.create(:user, login: 'alice') do |alice|
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github',
                                                                    uid: alice.id,
                                                                    info: { nickname: alice.login,
                                                                            name: alice.name,
                                                                            image: alice.avatar_url } })
    end
  end

  scenario 'ユーザーとしてログインに成功すること' do
    visit root_path
    click_button 'ログイン'

    expect(page).to have_current_path '/alice/issues?association=assigned'
    expect(page).to have_content 'ログインしました'
  end

  context 'ユーザーとして、アカウント登録ボタンをクリックした場合' do
    scenario 'ログインに成功すること' do
      visit root_path
      expect do
        click_button 'GitHubアカントで登録'

        expect(page).to have_current_path '/alice/issues?association=assigned'
        expect(page).to have_content 'ログインしました'
      end.not_to(change { User.count })
    end
  end

  scenario 'ユーザーとしてログアウトに成功すること' do
    visit root_path
    click_button 'ログイン'

    using_wait_time(5) do # フラッシュメッセージが閉じるのを待つ
      click_button 'alice'
      click_link 'ログアウト'
    end

    expect(page).to have_current_path '/'
    expect(page).to have_content 'ログアウトしました'
  end
end
