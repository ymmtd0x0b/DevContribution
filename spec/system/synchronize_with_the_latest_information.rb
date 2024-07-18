# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Synchronize with the latest information', type: :system do
  before do
    allow(Git::Wiki).to receive(:created_by).and_return([])
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')

    FactoryBot.create(:repository, id: 101, name: 'test/before_repository')
  end

  let(:alice) { FactoryBot.create(:user, id: 501, login: 'alice') }

  context '更新ボタンをクリックした場合', vcr: { cassette_name: 'system/synchronize_with_the_latest_information' } do
    scenario 'リポジトリの情報を同期すること' do
      login_as alice
      expect(page).to have_content 'test/before_repository'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_content 'test/after_repository'
    end

    scenario 'リポジトリのラベル情報を同期すること' do
      FactoryBot.create(:issue, id: 301, title: 'バグの修正') do |issue|
        issue.labels << FactoryBot.create(:label, id: 201, name: 'バグ', repository_id: 101)
        issue.assignees << alice
      end

      login_as alice
      visit users_issues_path alice.login, association: 'assigned'
      expect(page).to have_content 'バグの修正'
      expect(page).to have_content 'バグ'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_content 'バグの修正'
      expect(page).to have_content 'bug'
    end

    scenario 'ログインユーザーが担当した Issue の情報を同期すること' do
      FactoryBot.create(:issue, id: 301, title: 'bugの修正') { |issue| issue.assignee << alice }

      login_as alice
      visit users_issues_path alice.login, association: 'assigned'
      expect(page).to have_link 'bugの修正'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
    end

    scenario 'ログインユーザーがレビューした Issue の情報を同期すること' do
      FactoryBot.create(:pull_request, id: 403) do |pr|
        pr.issues << FactoryBot.create(:issue, id: 303, title: 'metaデータの変更')
        pr.reviewers << alice
      end

      login_as alice
      visit users_issues_path alice.login, association: 'reviewed'
      expect(page).to have_link 'metaデータの変更'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'メタデータの変更'
      expect(page).to have_link 'デザインの改修'
    end

    scenario 'ログインユーザーが作成した Issue の情報を同期すること' do
      FactoryBot.create(:issue, id: 305, title: 'bugの報告', user: alice)

      login_as alice
      visit users_issues_path alice.login
      expect(page).to have_link 'bugの報告'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'バグの報告'
      expect(page).to have_link '新機能の提案'
    end

    scenario 'ログインユーザーが作成した Wiki の情報を同期すること' do
      FactoryBot.create(:wiki, title: 'Before Wiki', first_commit_hash: 'aaa', repository_id: 101, user: alice)

      new_wiki = { user_id: alice.id, title: 'After Wiki', first_commit_hash: 'aaa', created_at: Time.zone.now, updated_at: Time.zone.now }
      allow(Git::Wiki).to receive(:created_by).and_return([Git::Wiki.new(repository_id: 101, file_data: new_wiki)])

      login_as alice
      visit users_wikis_path alice.login
      expect(page).to have_link 'Before Wiki'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'After Wiki'
    end
  end
end
