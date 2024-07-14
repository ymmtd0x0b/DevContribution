# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WikiDecorator do
  describe '#url' do
    it '「リポジトリのURL / wiki / Wikiのタイトル」に変換したURLを返すこと' do
      wiki = FactoryBot.create(:wiki, title: '議事録#001', repository: FactoryBot.create(:repository, name: 'test/repository'))
      decorator_wiki = ActiveDecorator::Decorator.instance.decorate(wiki)

      expect(decorator_wiki.url).to eq 'https://github.com/test/repository/wiki/議事録#001'
    end
  end
end
