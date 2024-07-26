# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  before do
    FactoryBot.create(:repository, id: 123, name: 'test/repository')
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github', uid: 501, info: { nickname: 'alice', name: '', image: '' } })

    @tmpdir_realpath = setup_dummpy_repository_wiki
    allow(Git::Wiki).to receive(:github_url).and_return(@tmpdir_realpath)
  end

  def setup_dummpy_repository_wiki
    tmpdir = Dir.mktmpdir
    tmpdir_realpath = File.realpath tmpdir

    Dir.chdir(tmpdir_realpath) do
      git = Git.init('test/repository.wiki.git')
      git.config('user.name', 'alice')

      git.chdir do
        File.write('議事録01.md', 'test')
        git.add('議事録01.md')
        git.commit('議事録の作成')

        File.write('議事録02.md', 'test')
        git.add('議事録02.md')
        git.commit('議事録の作成')
      end
    end

    tmpdir_realpath
  end

  after do
    FileUtils.remove_entry_secure @tmpdir_realpath if Dir.exist?(@tmpdir_realpath)
  end

  scenario 'ユーザー登録する', vcr: { cassette_name: 'system/sign_up' } do
    visit root_path
    expect do
      click_button 'GitHubアカントで登録'
      expect(page).to have_current_path '/alice/issues?association=assigned'
      expect(page).to have_content 'アカウント連携に成功しました'
      expect(page).to have_content 'alice'
    end.to change { User.count }.from(0).to(1)
  end

  context 'ゲストとして、ログインボタンをクリックした場合' do
    scenario 'ユーザー登録する', vcr: { cassette_name: 'system/sign_up' } do
      visit root_path
      expect do
        click_button 'ログイン'
        expect(page).to have_current_path '/alice/issues?association=assigned'
        expect(page).to have_content 'アカウント連携に成功しました'
        expect(page).to have_content 'alice'
      end.to change { User.count }.from(0).to(1)
    end
  end

  context 'ユーザー登録する際', vcr: { cassette_name: 'system/sign_up' } do
    before do
      visit root_path
      click_button 'GitHubアカントで登録'
      expect(page).to have_content 'アカウント連携に成功しました'
    end

    scenario 'ユーザーが作成した Issue を GitHub から取得＆登録する' do
      visit users_issues_path('alice')
      expect(page).to have_content 'Total 3'
      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
      expect(page).to have_link '機能の提案'
    end

    scenario 'ユーザーが担当した Issue を GitHub から取得＆登録する' do
      visit users_issues_path('alice', association: 'assigned')

      expect(page).to have_content 'Total 2'
      expect(page).to have_link 'バグの修正'
      expect(page).to have_link '新機能の追加'
    end

    scenario 'ユーザーがレビューした Issue を GitHub から取得＆登録する' do
      visit users_issues_path('alice', association: 'reviewed')

      expect(page).to have_content 'Total 2'
      expect(page).to have_link 'ロゴの変更'
      expect(page).to have_link '既存機能の改修'
    end

    scenario 'ユーザーが作成した Wiki を GitHub から取得＆登録する' do
      visit users_wikis_path('alice')

      expect(page).to have_content 'Total 2'
      expect(page).to have_link '議事録01'
      expect(page).to have_link '議事録02'
    end
  end
end
