# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssueDecorator do
  describe '#url' do
    it '「リポジトリのURL / issues / Issueのナンバー」に変換したURLを返すこと' do
      issue = FactoryBot.create(:issue, number: 123, repository: FactoryBot.create(:repository, name: 'test/repository'))
      decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

      expect(decorator_issue.url).to eq 'https://github.com/test/repository/issues/123'
    end
  end

  describe '#point' do
    let(:repository) { FactoryBot.create(:repository) }

    context 'ラベルが貼られていない場合' do
      it 'ゼロを返すこと' do
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(FactoryBot.create(:issue))
        expect(decorator_issue.point).to eq 0
      end
    end

    context 'ラベルが貼られている場合' do
      it 'ストーリーポイントとなるラベルがあれば、そのポイントを返すこと' do
        issue = FactoryBot.create(:issue) do |created_issue|
          created_issue.labelings.create!(label: FactoryBot.create(:label, :with_repository, repository:, name: '1'))
          created_issue.labelings.create!(label: FactoryBot.create(:label, :with_repository, repository:, name: 'good first issue'))
        end
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

        expect(decorator_issue.point).to eq 1
      end

      it 'ストーリーポイントとなるラベルがなけれが、ゼロを返すこと' do
        issue = FactoryBot.create(:issue) do |created_issue|
          created_issue.labelings.create!(label: FactoryBot.create(:label, :with_repository, repository:, name: 'good first issue'))
        end
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

        expect(decorator_issue.point).to eq 0
      end
    end
  end
end
