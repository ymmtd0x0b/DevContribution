# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssueDecorator do
  describe '#url' do
    it '「リポジトリのURL/pull/PullRequestのナンバー」に変換したURLを返すこと' do
      FactoryBot.create(:repository, id: 1, name: 'test/repository')
      pull_request = FactoryBot.create(:pull_request, :with_repository, repository_id: 1, number: 123)
      decorator_pull_request = ActiveDecorator::Decorator.instance.decorate(pull_request)

      expect(decorator_pull_request.url).to eq 'https://example.com/test/repository/pull/123'
    end
  end
end
