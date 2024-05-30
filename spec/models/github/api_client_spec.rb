# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::ApiClient, type: :model do
  before do
    @client = Github::ApiClient.new
    allow(Rails.logger).to receive(:error)
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
        @client.repository(name: 'ymmtd0x0b/not_found')
        expect(Rails.logger).to have_received(:error).with(/[GitHub API] .+/)
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
        @client.search_issues('repo:ymmtd0x0b/for_test2 is:issue author:not_exist_user')
        expect(Rails.logger).to have_received(:error).with(/[GitHub API] .+/)
      end
    end
  end

  describe '#labels' do
    context 'リポジトリに登録されているラベルが１つ以上ある場合' do
      it 'Sawyer::Resourceオブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/api_client/labels' } do
        labels = @client.labels('ymmtd0x0b/for_test2')
        expect(labels).not_to be_empty
        expect(labels).to all(be_instance_of(Sawyer::Resource))
      end
    end

    context 'リポジトリに登録されているラベルがゼロの場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/api_client/labels_nothing' } do
        labels = @client.labels('ymmtd0x0b/for_test2')
        expect(labels).to be_empty
      end
    end

    context 'エラーが発生した場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/api_client/labels_error' } do
        labels = @client.labels('ymmtd0x0b/not_exist_repository')
        expect(labels).to be_empty
      end

      it 'ログへ出力すること', vcr: { cassette_name: 'github/api_client/labels_error' } do
        @client.labels('ymmtd0x0b/not_exist_repository')
        expect(Rails.logger).to have_received(:error).with(/[GitHub API] .+/)
      end
    end
  end
end
