# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Issues', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')
    allow(Git::Wiki).to receive(:created_by).and_return([])

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github', uid: 501, info: { nickname: 'alice', name: '', image: '' } })

    FactoryBot.create(:repository, id: 101, name: 'test/repository')
  end

  context 'サインアップする際', vcr: { cassette_name: 'system/sign_up' } do
    scenario 'ユーザーが作成した Issue を GitHub から取得＆登録する' do
      visit root_path
      expect do
        click_button 'GitHubアカントで登録'
        expect(page).to have_content 'アカウント連携に成功しました'
      end.to change { User.count }.from(0).to(1)

      visit users_issues_path('alice')

      expect(page).to have_content 'Total 3'
      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
      expect(page).to have_link '機能の提案'
    end

    scenario 'ユーザーが担当した Issue を GitHub から取得＆登録する' do
      visit root_path
      expect do
        click_button 'GitHubアカントで登録'
        expect(page).to have_content 'アカウント連携に成功しました'
      end.to change { User.count }.from(0).to(1)

      visit users_issues_path('alice', association: 'assigned')
      expect(page).to have_content 'Total 2'
      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
    end

    scenario 'ユーザーがレビューした Issue を GitHub から取得＆登録する' do
      visit root_path
      expect do
        click_button 'GitHubアカントで登録'
        expect(page).to have_content 'アカウント連携に成功しました'
      end.to change { User.count }.from(0).to(1)

      visit users_issues_path('alice', association: 'reviewed')
      expect(page).to have_content 'Total 2'
      expect(page).to have_link 'ロゴの変更'
      expect(page).to have_link '既存機能の改修'
    end
  end
end
