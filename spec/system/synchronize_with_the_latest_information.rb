# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Synchronize with the latest information', type: :system do
  before do
    FactoryBot.create(:repository, id: 123, name: 'test/before_repository')
    allow(Git::Wiki).to receive(:created_by).and_return([])
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
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 301, title: 'バグの修正') do |issue|
        issue.labels << FactoryBot.create(:label, id: 201, name: 'バグ', repository_id: 123)
        issue.assignees << alice
      end

      login_as alice
      visit users_issues_path(alice.login, association: 'assigned')
      expect(page).to have_content 'バグの修正'
      expect(page).to have_content 'バグ'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_content 'バグの修正'
      expect(page).to have_content 'bug'
    end

    scenario 'ログインユーザーが担当した Issue の情報を同期すること' do
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 301, title: 'bugの修正') { |issue| issue.assignees << alice }

      login_as alice
      visit users_issues_path(alice.login, association: 'assigned')
      expect(page).to have_link 'bugの修正'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
    end

    scenario 'ログインユーザーがレビューした Issue の情報を同期すること' do
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 303, title: 'metaデータの変更') do |issue|
        issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123, id: 403) { |pr| pr.reviewers << alice }
      end

      login_as alice
      visit users_issues_path(alice.login, association: 'reviewed')
      expect(page).to have_link 'metaデータの変更'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'メタデータの変更'
      expect(page).to have_link 'デザインの改修'
    end

    scenario 'ログインユーザーが作成した Issue の情報を同期すること' do
      FactoryBot.create(:issue, :with_repository, repository_id: 123, id: 305, title: 'bugの報告', user: alice)

      login_as alice
      visit users_issues_path(alice.login)
      expect(page).to have_link 'bugの報告'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'バグの報告'
      expect(page).to have_link '新機能の提案'
    end

    scenario 'ログインユーザーが作成した Wiki の情報を同期すること' do
      FactoryBot.create(:wiki, title: 'Before Wiki', first_commit_hash: 'abc', repository_id: 123, user: alice)

      latest_wiki = { user_id: alice.id, title: 'After Wiki', first_commit_hash: 'abc', created_at: Time.zone.now, updated_at: Time.zone.now }
      allow(Git::Wiki).to receive(:created_by).and_return([Git::Wiki.new(repository_id: 123, file_data: latest_wiki)])

      login_as alice
      visit users_wikis_path(alice.login)
      expect(page).to have_link 'Before Wiki'

      click_button '最新情報へ更新'
      click_button 'OK', class: 'swal2-confirm'
      expect(page).to have_content '更新に成功しました'

      expect(page).to have_link 'After Wiki'
    end
  end
end
