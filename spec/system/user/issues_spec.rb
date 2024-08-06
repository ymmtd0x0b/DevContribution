# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Issues', type: :system do
  before do
    @repository = FactoryBot.create(:repository, id: 123, name: 'test/repository')
  end

  scenario 'ユーザーが作成した Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue A', user: alice)
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue B', user: alice)

    login_as alice
    visit users_issues_path(alice.login)

    expect(page).to have_content 'Total 2'
    expect(page).to have_link 'Issue A'
    expect(page).to have_link 'Issue B'
  end

  scenario 'ユーザーが担当した Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue C') { |issue| issue.assignees << alice }
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue D') { |issue| issue.assignees << alice }

    login_as alice
    visit users_issues_path(alice.login, association: 'assigned')

    expect(page).to have_link 'Issue C'
    expect(page).to have_link 'Issue D'
  end

  scenario 'ユーザーがレビューした Issue を一覧表示する' do
    alice = FactoryBot.create(:user, login: 'alice')
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue E') do |issue|
      issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << alice }
    end
    FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue F') do |issue|
      issue.pull_requests << FactoryBot.create(:pull_request, :with_repository, repository_id: 123) { |pr| pr.reviewers << alice }
    end

    login_as alice
    visit users_issues_path(alice.login, association: 'reviewed')

    expect(page).to have_link 'Issue E'
    expect(page).to have_link 'Issue F'
  end

  context 'Issue にラベルが付与されている場合' do
    scenario 'Issue と共に一覧に表示する' do
      alice = FactoryBot.create(:user, login: 'alice')
      FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue G', user: alice) do |issue|
        issue.labels << FactoryBot.create(:label, :with_repository, repository: @repository, name: '1')
      end
      FactoryBot.create(:issue, :with_repository, repository_id: 123, title: 'Issue H', user: alice) do |issue|
        issue.labels << FactoryBot.create(:label, :with_repository, repository: @repository, name: '2')
        issue.labels << FactoryBot.create(:label, :with_repository, repository: @repository, name: 'bug')
      end

      login_as alice
      visit users_issues_path(alice.login)

      expect(page).to have_content 'Total 2'
      expect(page).to have_link 'Issue G'
      expect(page).to have_content '1'
      expect(page).to have_link 'Issue H'
      expect(page).to have_content '2'
      expect(page).to have_content 'bug'
    end
  end

  context 'ゲストとしてアクセスした場合' do
    scenario 'トップページへリダイレクトされる' do
      visit users_issues_path('alice')
      expect(page).to have_content 'ログインしてください'
      expect(page).to have_current_path '/'

      visit users_issues_path('alice', association: 'assigned')
      expect(page).to have_content 'ログインしてください'
      expect(page).to have_current_path '/'

      visit users_issues_path('alice', association: 'reviewed')
      expect(page).to have_content 'ログインしてください'
      expect(page).to have_current_path '/'
    end
  end
end
