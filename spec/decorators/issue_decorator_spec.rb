# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssueDecorator do
  describe '#url' do
    it '「リポジトリのURL/issues/Issueのナンバー」に変換したURLを返すこと' do
      FactoryBot.create(:repository, id: 123, name: 'test/repository')
      issue = FactoryBot.create(:issue, :with_repository, repository_id: 123, number: 456)
      decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

      expect(decorator_issue.url).to eq 'https://example.com/test/repository/issues/456'
    end
  end

  describe '#point' do
    before do
      FactoryBot.create(:repository, id: 123)
    end

    context 'ラベルが貼られていない場合' do
      it 'ゼロを返すこと' do
        issue = FactoryBot.create(:issue, :with_repository, repository_id: 123)
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)
        expect(decorator_issue.point).to eq 0
      end
    end

    context 'ラベルが貼られている場合' do
      it 'ストーリーポイントとなるラベルがあれば、そのポイントを返すこと' do
        issue = FactoryBot.create(:issue, :with_repository, repository_id: 123)
        issue.labels << FactoryBot.create(:label, :with_repository, repository_id: 123, name: '1')
        issue.labels << FactoryBot.create(:label, :with_repository, repository_id: 123, name: 'good first issue')
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

        expect(decorator_issue.point).to eq 1
      end

      it 'ストーリーポイントとなるラベルがなけれが、ゼロを返すこと' do
        issue = FactoryBot.create(:issue, :with_repository, repository_id: 123)
        issue.labels << FactoryBot.create(:label, :with_repository, repository_id: 123, name: 'good first issue')
        decorator_issue = ActiveDecorator::Decorator.instance.decorate(issue)

        expect(decorator_issue.point).to eq 0
      end
    end
  end
end
