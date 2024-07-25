# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe '.synchronize' do
    let(:repository) { FactoryBot.create(:repository, id: 1) }

    context '引数に渡されたデータの中に「未登録のラベル」がある場合' do
      it '新たに登録すること' do
        FactoryBot.create(:label, :with_repository, repository:, id: 100, name: 'label#100')

        expect do
          issues_collected_by_the_github_api = [
            GitHub::Label.new(repository_id: 1, label: { id: 100, name: 'label#100', color: '' }),
            GitHub::Label.new(repository_id: 1, label: { id: 200, name: 'label#200', color: '' })
          ]
          Label.synchronize(repository, issues_collected_by_the_github_api)
        end.to change { Label.pluck(:id) }.from([100]).to([100, 200])
      end
    end

    context '引数に渡されたデータの中に「登録済みのラベル 」がある場合' do
      it '該当ラベルの情報を更新すること' do
        label = FactoryBot.create(:label, :with_repository, repository:, id: 100, name: 'label#100')

        expect do
          labels_collected_by_the_github_api = [
            GitHub::Label.new(repository_id: 1, label: { id: 100, name: 'bug', color: '' })
          ]
          Label.synchronize(repository, labels_collected_by_the_github_api)
        end.to change { label.reload.name }.from('label#100').to('bug')
      end
    end

    context '引数に渡されたデータの中に「登録済みのラベル」がない場合' do
      it '該当ラベルを削除すること' do
        FactoryBot.create(:label, id: 100, name: 'label#100', repository:)
        FactoryBot.create(:label, id: 200, name: 'label#200', repository:)

        expect do
          labels_collected_by_the_github_api = [
            GitHub::Label.new(repository_id: 1, label: { id: 100, name: 'label#100', color: '' })
          ]
          Label.synchronize(repository, labels_collected_by_the_github_api)
        end.to change { Label.pluck(:name) }.from(['label#100', 'label#200']).to(['label#100'])
      end
    end
  end
end
