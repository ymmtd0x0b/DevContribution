# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WikiDecorator do
  describe '#url' do
    it '「リポジトリのURL / wiki / Wikiのタイトル」に変換したURLを返すこと' do
      FactoryBot.create(:repository, id: 1, name: 'test/repository')
      wiki = FactoryBot.create(:wiki, :with_repository, :with_user, repository_id: 1, title: '議事録#001')
      decorator_wiki = ActiveDecorator::Decorator.instance.decorate(wiki)

      expect(decorator_wiki.url).to eq 'https://example.com/test/repository/wiki/議事録#001'
    end
  end
end
