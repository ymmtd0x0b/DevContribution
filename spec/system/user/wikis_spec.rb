# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Wikis', type: :system do
  before do
    @tmpdir_realpath = setup_dummpy_repository_wiki
    FactoryBot.create(:repository, id: 101, name: 'test/repository', url: "#{@tmpdir_realpath}/test_repository")

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github',
                                                                  uid: 501,
                                                                  info: { nickname: 'alice',
                                                                          name: 'アリス',
                                                                          image: '' } })
  end

  after do
    FileUtils.remove_entry_secure @tmpdir_realpath if Dir.exist?(@tmpdir_realpath)
  end

  def setup_dummpy_repository_wiki
    tmpdir = Dir.mktmpdir
    tmpdir_realpath = File.realpath tmpdir

    Dir.chdir(tmpdir_realpath) do
      git = Git.init('test_repository.wiki.git')
      git.config('user.name', 'alice')

      File.write('test_repository.wiki.git/議事録01.md', 'test')
      git.add('議事録01.md')
      git.commit('議事録の作成')

      File.write('test_repository.wiki.git/議事録02.md', 'test')
      git.add('議事録02.md')
      git.commit('議事録の作成')
    end

    tmpdir_realpath
  end

  scenario 'サインアップする際、ユーザーが作成した Wiki を GitHub から取得＆登録する', vcr: { cassette_name: 'system/sign_up' } do
    visit root_path
    expect do
      click_button 'GitHubアカントで登録'
      expect(page).to have_content 'アカウント連携に成功しました'
    end.to change { User.count }.from(0).to(1)

    visit users_wikis_path('alice')
    expect(page).to have_content 'Total 2'
    expect(page).to have_content '議事録01'
    expect(page).to have_content '議事録02'
  end
end
