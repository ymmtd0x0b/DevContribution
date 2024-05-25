# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::ApiClient, type: :model do
  before do
    @client = Github::ApiClient.new
  end

  describe '#repository' do
    context 'リポジトリを見つけた場合' do
      it 'Sawyer::Resourceオブジェクトを返すこと', vcr: { cassette_name: 'github/api_client/repository' } do
        actual = @client.repository(name: 'fjordllc/bootcamp')
        expect(actual).to be_an_instance_of(Sawyer::Resource)
      end
    end

    context 'エラーが発生した場合(リポジトリが見つからない場合もエラーに含む)' do
      it 'nilを返すこと', vcr: { cassette_name: 'github/api_client/repository_with_not_found' } do
        actual = @client.repository(name: 'ymmtd0x0b/not_found')
        expect(actual).to eq nil
      end

      it 'ログへ出力すること', vcr: { cassette_name: 'github/api_client/repository_with_not_found' } do
        log_message = '[GitHub API] GET https://api.github.com/repos/ymmtd0x0b/not_found: 404 - Not Found // See: https://docs.github.com/rest/repos/repos#get-a-repository'
        expect(Rails.logger).to receive(:error).with(log_message)

        @client.repository(name: 'ymmtd0x0b/not_found')
      end
    end
  end

  describe '#search_issues' do
    context '該当する issue を見つけた場合' do
      it 'Swayer::Resourceオブジェクトで構成された Array を返すこと', vcr: { cassette_name: 'github/api_client/search_issues' } do
        actual = @client.search_issues('repo:fjordllc/bootcamp is:issue author:ymmtd0x0b')
        expect(actual).to all(be_instance_of(Sawyer::Resource))
      end
    end

    context '該当する issue が見つからない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/api_client/search_issues_with_not_found' } do
        actual = @client.search_issues('repo:ymmtd0x0b/for_test2 is:issue author:ymmtd0x0b label:not_exist_tag')
        expect(actual).to be_empty
      end
    end

    context 'エラーが発生した場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/api_client/search_issues_with_not_exist_user' } do
        actual = @client.search_issues('repo:ymmtd0x0b/for_test2 is:issue author:not_exist_user')
        expect(actual).to be_empty
      end

      it 'ログへ出力すること', vcr: { cassette_name: 'github/api_client/search_issues_with_not_exist_user' } do
        log_message = <<~TEXT.chomp
          [GitHub API] GET https://api.github.com/search/issues?page=1&per_page=100&q=repo%3Aymmtd0x0b%2Ffor_test2+is%3Aissue+author%3Anot_exist_user: 422 - Validation Failed
          Error summary:
            message: The listed users cannot be searched either because the users do not exist or you do not have permission to view the users.
            resource: Search
            field: q
            code: invalid // See: https://docs.github.com/v3/search/
        TEXT
        expect(Rails.logger).to receive(:error).with(log_message)

        @client.search_issues('repo:ymmtd0x0b/for_test2 is:issue author:not_exist_user')
      end
    end
  end
end
