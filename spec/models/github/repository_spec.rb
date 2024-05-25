# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Repository, type: :model do
  describe '#to_h' do
    it 'id, name, url, avatar_url をキーに持つハッシュ(連想配列)を返すこと' do
      repository = Github::Repository.new(id: 123,
                                          name: 'test_repository',
                                          url: 'https://example.com/test_repository',
                                          avatar_url: 'https://example.com/test_repository/avatar.jpg')

      expect(repository.to_h).to eq({ id: 123,
                                      name: 'test_repository',
                                      url: 'https://example.com/test_repository',
                                      avatar_url: 'https://example.com/test_repository/avatar.jpg' })
    end
  end

  describe '.find_by' do
    # TODO
    # カセットに機密情報が記録されないように設定を追加する
    context 'リポジトリを見つけた場合' do
      it 'Github::Resitoryオブジェクトのインスタンスを返すこと', vcr: { cassette_name: 'github/api_client/repository' } do
        actual = Github::Repository.find_by(name: 'fjordllc/bootcamp')
        expect(actual).to be_an_instance_of(Github::Repository)
      end
    end

    context 'リポジトリが見つからない場合' do
      it 'nilを返すこと', vcr: { cassette_name: 'github/api_client/repository_with_not_found' } do
        actual = Github::Repository.find_by(name: 'ymmtd0x0b/not_found')
        expect(actual).to eq nil
      end
    end
  end
end
