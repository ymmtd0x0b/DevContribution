# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('123')

    FactoryBot.create(:repository, id: 123)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github',
                                                                  uid: 123_45,
                                                                  info: { nickname: 'alice',
                                                                          name: 'アリス',
                                                                          image: 'https://example.com/avatar.jpg' } })
    allow(Newspaper).to receive(:publish)
  end

  scenario 'ユーザー登録できること' do
    visit root_path
    expect { click_button 'GitHubアカントで登録' }.to change { User.count }.from(0).to(1)
    expect(page).to have_current_path '/alice/issues?association=assigned'
    expect(page).to have_content 'アカウント連携に成功しました'
  end

  context 'ゲストとして、ログインボタンをクリックした場合' do
    scenario 'ユーザー登録できること' do
      visit root_path
      expect { click_button 'ログイン' }.to change { User.count }.from(0).to(1)
      expect(page).to have_current_path '/alice/issues?association=assigned'
      expect(page).to have_content 'アカウント連携に成功しました'
    end
  end
end
