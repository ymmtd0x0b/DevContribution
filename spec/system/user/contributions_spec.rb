# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Contributions', type: :system do
  before do
    FactoryBot.create(:repository, id: 123, name: 'test/repository')
  end

  scenario 'ユーザーの 作成/担当/レビューした Issue とそれと紐付いた PullRequest 、Wiki を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')

    FactoryBot.create(:issue, title: 'アリスが担当した Issue') do |issue|
      issue.assignees << alice
      issue.pull_requests << FactoryBot.create(:pull_request, number: 111) { |pr| pr.assignees << alice }
    end

    FactoryBot.create(:issue, title: 'アリスがレビューした Issue') do |issue|
      issue.pull_requests << FactoryBot.create(:pull_request, number: 222) { |pr| pr.reviewers << alice }
    end

    FactoryBot.create(:issue, title: 'アリスが作成した Issue', user: alice)
    FactoryBot.create(:wiki, title: 'アリスが作成した Wiki', user: alice)

    login_as alice
    visit users_contributions_path alice.login

    expect(page).to have_button('Markdownをコピー')
    expect(page).to have_button('URLをコピー')
    expect(page).to have_link('アリスが担当した Issue')
    expect(page).to have_link('#111')
    expect(page).to have_link('アリスがレビューした Issue')
    expect(page).to have_link('#222')
    expect(page).to have_link('アリスが作成した Issue')
    expect(page).to have_link('アリスが作成した Wiki')
  end

  context 'ゲストとしてアクセスした場合' do
    scenario '見出しを変更し、コピーボタン無しで表示する' do
      FactoryBot.create(:user, login: 'alice')

      visit users_contributions_path('alice')

      expect(page).to have_element('h1', text: 'チーム開発プラクティスでのaliceさんの取り組み')
      expect(page).not_to have_button('Markdownをコピー')
      expect(page).not_to have_button('URLをコピー')
    end
  end
end
