# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Issues', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')

    FactoryBot.create(:repository, id: 101, name: 'test/repository')
  end

  scenario 'ユーザーが作成した Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, title: 'Issue A', user: alice)
    FactoryBot.create(:issue, title: 'Issue B', user: alice)

    login_as alice
    visit users_issues_path(alice.login)

    expect(page).to have_link 'Issue A'
    expect(page).to have_link 'Issue B'
  end

  scenario 'ユーザーが担当した Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, title: 'Issue C') { |issue| issue.assignees << alice }
    FactoryBot.create(:issue, title: 'Issue D') { |issue| issue.assignees << alice }

    login_as alice
    visit users_issues_path(alice.login, association: 'assigned')

    expect(page).to have_link 'Issue C'
    expect(page).to have_link 'Issue D'
  end

  scenario 'ユーザーがレビューした Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, title: 'Issue E') { |issue| issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.reviewers << alice } }
    FactoryBot.create(:issue, title: 'Issue F') { |issue| issue.pull_requests << FactoryBot.create(:pull_request) { |pr| pr.reviewers << alice } }

    login_as alice
    visit users_issues_path(alice.login, association: 'reviewed')

    expect(page).to have_link 'Issue E'
    expect(page).to have_link 'Issue F'
  end
end
