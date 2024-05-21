# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssueDecorator do
  describe '#url' do
    it '「リポジトリのURL / pull / PullRequestのナンバー」に変換したURLを返すこと' do
      pull_request = FactoryBot.create(:pull_request, number: 123, repository: FactoryBot.create(:repository, url: 'https://example.com/test_repository'))
      decorator_pull_request = ActiveDecorator::Decorator.instance.decorate(pull_request)

      expect(decorator_pull_request.url).to eq 'https://example.com/test_repository/pull/123'
    end
  end
end
