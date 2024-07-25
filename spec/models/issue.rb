# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  it '有効なファクトリを持つこと' do
    pull_request = FactoryBot.create(:pull_request)
    expect(pull_request).to be_valid
  end

  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1)
      allow(Labeling).to receive(:synchronize)
    end

    context '引数に渡されたデータの中に「未登録の Issue 」がある場合' do
      it '新たに登録すること' do
        FactoryBot.create(:issue, id: 100, title: 'issue#100', number: 100)

        expect do
          issues_collected_by_the_github_api = [
            GitHub::Issue.new(repository_id: 1, issue: { id: 100, user_id: 1, title: 'issue#100', number: 100, labels_id: [] }),
            GitHub::Issue.new(repository_id: 1, issue: { id: 200, user_id: 1, title: 'issue#200', number: 200, labels_id: [] })
          ]
          Issue.synchronize(issues_collected_by_the_github_api)
        end.to change { Issue.count }.from(1).to(2)
      end
    end

    context '引数に渡されたデータの中に「登録済みの Issue 」がある場合' do
      it '該当 Issue の情報を更新すること' do
        issue = FactoryBot.create(:issue, id: 100, title: 'before update...')

        expect do
          issues_collected_by_the_github_api = [
            GitHub::Issue.new(repository_id: 1, issue: { id: 100, user_id: 1, title: 'updated!', number: 100, labels_id: [] })
          ]
          Issue.synchronize(issues_collected_by_the_github_api)
        end.to change { issue.reload.title }.from('before update...').to('updated!')
      end
    end

    it 'Issue のラベリングを同期させる(メソッドを呼び出す)こと' do
      issues_collected_by_the_github_api = [
        GitHub::Issue.new(repository_id: 1, issue: { id: 100, user_id: 1, title: 'issue#100', number: 100, labels_id: [123] })
      ]
      Issue.synchronize(issues_collected_by_the_github_api)

      expect(Labeling).to have_received(:synchronize)
    end
  end
end
