# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Contributions', type: :system do
  before do
    @tmpdir_realpath = setup_dummpy_repository_wiki
    FactoryBot.create(:repository, id: 123, name: 'test/repository', url: "#{@tmpdir_realpath}/test_repository")

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('123')
  end

  def setup_dummpy_repository_wiki
    tmpdir = Dir.mktmpdir
    tmpdir_realpath = File.realpath tmpdir
    Dir.chdir(tmpdir_realpath) { Git.init('test_repository.wiki.git') }

    tmpdir_realpath
  end

  after do
    FileUtils.remove_entry_secure @tmpdir_realpath if Dir.exist?(@tmpdir_realpath)
  end

  scenario 'ユーザーに関連する Issue や PR を FBC の提出物フォーマットに従って、一覧表示を行う' do
    FactoryBot.create(:user, id: 456, login: 'alice') do |alice|
      FactoryBot.create(:issue, title: 'アリスが担当した Issue') do |issue|
        issue.assigns.create!(user: alice)
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request, number: 111) { |pr| pr.assigns.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'アリスがレビューした Issue') do |issue|
        issue.resolutions.create!(pull_request: FactoryBot.create(:pull_request, number: 222) { |pr| pr.reviews.create!(user: alice) })
      end

      FactoryBot.create(:issue, title: 'アリスが作成した Issue', user: alice)
      FactoryBot.create(:wiki, title: 'アリスが作成した Wiki', user: alice)
    end

    visit_with_onmiauth(path: users_contributions_path('alice'), user: alice)
    expect(page).to have_button('Copy')
    expect(page).to have_link('アリスが担当した Issue')
    expect(page).to have_link('#111')
    expect(page).to have_link('アリスがレビューした Issue')
    expect(page).to have_link('#222')
    expect(page).to have_link('アリスが作成した Issue')
    expect(page).to have_link('アリスが作成した Wiki')
  end
end
