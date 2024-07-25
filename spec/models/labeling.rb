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
        FactoryBot.create(:issue, id: 100) { |created_issue| created_issue.labelings.create!(label_id: 123) }

        expect do
          issues_collected_by_the_github_api = [GitHub::Issue.new(repository_id: 1, issue: { id: 100, labels_id: [123, 456] })]
          Labeling.synchronize(issues_collected_by_the_github_api)
        end.to change { Labeling.where(issue_id: 100).pluck(:label_id) }.from([123]).to([123, 456])
      end
    end

    context '引数に渡された Issue の labels_id に、既存のアソシエーションのラベル情報が存在しない場合' do
      it '対象のアソシエーションを削除する' do
        FactoryBot.create(:issue, id: 100) do |created_issue|
          created_issue.labelings.create!(label_id: 123)
          created_issue.labelings.create!(label_id: 456)
        end

        expect do
          issues_collected_by_the_github_api = [GitHub::Issue.new(repository_id: 1, issue: { id: 100, labels_id: [123] })]
          Labeling.synchronize(issues_collected_by_the_github_api)
        end.to change { Labeling.where(issue_id: 100).pluck(:label_id) }.from([123, 456]).to([123])
      end
    end
  end
end
