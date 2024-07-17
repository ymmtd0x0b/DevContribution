# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')
    allow(Git::Wiki).to receive(:created_by).and_return([])

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github', uid: 501, info: { nickname: 'alice', name: '', image: '' } })

    FactoryBot.create(:repository, id: 101, name: 'test/repository')
  end

  scenario 'ユーザー登録できること', vcr: { cassette_name: 'system/sign_up' } do
    visit root_path
    expect do
      click_button 'GitHubアカントで登録'
      expect(page).to have_current_path '/alice/issues?association=assigned'
      expect(page).to have_content 'アカウント連携に成功しました'
      expect(page).to have_content 'alice'
    end.to change { User.count }.from(0).to(1)
  end

  context 'ゲストとして、ログインボタンをクリックした場合' do
    scenario 'ユーザー登録できること', vcr: { cassette_name: 'system/sign_up' } do
      visit root_path
      expect do
        click_button 'ログイン'
        expect(page).to have_current_path '/alice/issues?association=assigned'
        expect(page).to have_content 'アカウント連携に成功しました'
        expect(page).to have_content 'alice'
      end.to change { User.count }.from(0).to(1)
    end
  end
end
