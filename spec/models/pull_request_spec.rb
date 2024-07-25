# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  it '有効なファクトリを持つこと' do
    pull_request = FactoryBot.create(:pull_request)
    expect(pull_request).to be_valid
  end

  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
      allow(Resolution).to receive(:synchronize)
    end

    context '引数に渡されたデータの中に「未登録のPullRequest」がある場合' do
      it '新たに登録すること' do
        FactoryBot.create(:pull_request, id: 100, number: 100)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 100, issues_number: [] }),
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 200, number: 200, issues_number: [] })
          ]
          PullRequest.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { PullRequest.ids }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に「登録済みのPullRequest」がある場合' do
      it '対象の情報を更新すること' do
        pull_request = FactoryBot.create(:pull_request, id: 100, number: 100)

        expect do
          pull_requests_collected_by_the_github_api = [
            GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 999, issues_number: [] })
          ]
          PullRequest.synchronize(pull_requests_collected_by_the_github_api)
        end.to change { pull_request.reload.number }.from(100).to(999)
      end
    end

    it 'PullRequest の description にリンクされた Issue とのアソシエーションを同期させる(メソッドを呼び出す)こと' do
      pull_requests_collected_by_the_github_api = [
        GitHub::PullRequest.new(repository_id: 1, pull_request: { id: 100, number: 999, issues_number: [123] })
      ]
      PullRequest.synchronize(pull_requests_collected_by_the_github_api)
      expect(Resolution).to have_received(:synchronize)
    end
  end

  describe '#assignee?' do
    context 'ユーザーがアサインされている場合' do
      it 'true を返すこと' do
        user = FactoryBot.create(:user)
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user_id: user.id) }

        expect(pull_request.assignee?(user)).to eq true
      end
    end

    context 'ユーザーがアサインされていない場合' do
      it 'false を返すこと' do
        user = FactoryBot.create(:user)
        pull_request = FactoryBot.create(:pull_request)

        expect(pull_request.assignee?(user)).to eq false
      end
    end
  end
end
