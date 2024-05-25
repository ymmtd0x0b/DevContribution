# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::ApiClient, type: :model do
  describe '#repository' do
    context 'リポジトリを見つけた場合' do
      it 'Sawyer::Resourceオブジェクトのインスタンスを返すこと', vcr: { cassette_name: 'github/api_client/repository' } do
        client = Github::ApiClient.new
        actual = client.repository(name: 'fjordllc/bootcamp')
        expect(actual).to be_an_instance_of(Sawyer::Resource)
      end
    end

    context 'リポジトリが見つからない場合' do
      it 'nilを返すこと', vcr: { cassette_name: 'github/api_client/repository_with_not_found' } do
        client = Github::ApiClient.new
        actual = client.repository(name: 'ymmtd0x0b/not_found')
        expect(actual).to eq nil
      end

      it '結果をログへ出力すること', vcr: { cassette_name: 'github/api_client/repository_with_not_found' } do
        expect(Rails.logger).to receive(:error).with('[GitHub API] GET https://api.github.com/repos/ymmtd0x0b/not_found: 404 - Not Found // See: https://docs.github.com/rest/repos/repos#get-a-repository')
        client = Github::ApiClient.new
        client.repository(name: 'ymmtd0x0b/not_found')
      end
    end
  end
end
