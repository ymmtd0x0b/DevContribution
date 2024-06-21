# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedIssue, type: :model do
  describe '#call' do
    let(:assigned_issue_destroyer) { Destroyer::AssignedIssue.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '削除対象となる Issue を、他のユーザーが参照していない場合' do
      it 'ユーザーがアサインしている Issue を削除すること' do
        FactoryBot.create(:issue, id: 100, title: 'アリスがアサインしている Issue (PR無し)') do |issue|
          issue.assigns.create!(user: alice)
        end

        FactoryBot.create(:issue, id: 200, title: 'アリスがアサインしている Issue (関連する PR をアリスがアサインしている)') do |issue|
          issue.assigns.create!(user: alice)
          FactoryBot.create(:pull_request) do |pull_request|
            pull_request.assigns.create!(user: alice)
            pull_request.resolutions.create!(issue:)
          end
        end

        FactoryBot.create(:issue, id: 300, title: 'アリスがアサインしている Issue (関連する PR をアリスがレビューしている)') do |issue|
          issue.assigns.create!(user: alice)
          FactoryBot.create(:pull_request) do |pull_request|
            pull_request.reviews.create!(user: alice)
            pull_request.resolutions.create!(issue:)
          end
        end

        expect do
          assigned_issue_destroyer.call(alice)
        end.to change { Issue.pluck(:id) }.from([100, 200, 300]).to([])
      end
    end

    context '削除対象となる Issue を、他のユーザーが参照してる場合' do
      it 'ユーザーがアサインしている Issue を削除しないこと' do
        FactoryBot.create(:issue, id: 100, title: '他のユーザーも Issue にアサインしている') do |issue|
          issue.assigns.create!(user: alice)
          issue.assigns.create!(user: bob)
        end

        FactoryBot.create(:issue, id: 200, title: 'アリスがアサインしている Issue (関連する PR をボブがアサインしている)') do |issue|
          issue.assigns.create!(user: alice)
          FactoryBot.create(:pull_request) do |pull_request|
            pull_request.assigns.create!(user: bob)
            pull_request.resolutions.create!(issue:)
          end
        end

        FactoryBot.create(:issue, id: 300, title: 'アリスがアサインしている Issue (関連する PR をボブがレビューしている)') do |issue|
          issue.assigns.create!(user: alice)
          FactoryBot.create(:pull_request) do |pull_request|
            pull_request.reviews.create!(user: bob)
            pull_request.resolutions.create!(issue:)
          end
        end

        FactoryBot.create(:issue, id: 400, user: bob, title: 'アリスがアサインしている Issue (作者のボブがデータベース上に存在する)') do |issue|
          issue.assigns.create!(user: alice)
        end

        expect do
          assigned_issue_destroyer.call(alice)
        end.not_to change { Issue.pluck(:id) }.from([100, 200, 300, 400])
      end
    end
  end
end
