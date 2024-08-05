# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Labeling, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 1) do |repository|
        FactoryBot.create(:label, repository:, id: 123)
        FactoryBot.create(:label, repository:, id: 456)
      end
    end

    context '引数に渡された Issue の labels_id に、既存のアソシエーションに該当しないラベル情報が存在する場合' do
      it '対象ラベルと Issue のアソシエーションを登録する' do
        issue = FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100)
        issue.labelings.create!(label_id: 123)

        expect do
          issues_collected_by_the_github_api = [GitHub::Issue.new(repository_id: 1, issue: { id: 100, labels_id: [123, 456] })]
          Labeling.synchronize(issues_collected_by_the_github_api)
        end.to change { issue.labels.ids }.from([123]).to([123, 456])
      end
    end

    context '引数に渡された Issue の labels_id に、既存のアソシエーションのラベル情報が存在しない場合' do
      it '対象のアソシエーションを削除する' do
        issue = FactoryBot.create(:issue, :with_repository, repository_id: 1, id: 100)
        issue.labelings.create!(label_id: 123)
        issue.labelings.create!(label_id: 456)

        expect do
          issues_collected_by_the_github_api = [GitHub::Issue.new(repository_id: 1, issue: { id: 100, labels_id: [123] })]
          Labeling.synchronize(issues_collected_by_the_github_api)
        end.to change { issue.labels.ids }.from([123, 456]).to([123])
      end
    end
  end
end
