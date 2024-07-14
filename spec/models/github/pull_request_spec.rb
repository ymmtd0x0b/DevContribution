# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::PullRequest, type: :model do
  describe '#to_h' do
    it '自身をハッシュ(連想配列)へ変換して返すこと( issues_number は含まない )' do
      pull_request_data = { id: 111, number: 222, issues_number: [333, 444] }
      pull_request = Github::PullRequest.new(repository_id: 123, pull_request: pull_request_data)

      expect(pull_request.to_h).to eq({ repository_id: 123, id: 111, number: 222 })
    end
  end

  describe '.assigned_by' do
    context '該当する PullRequest がある場合' do
      it 'Github::PullRequest オブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/pull_request/assigned_by' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b')

        pull_requests = Github::PullRequest.assigned_by(repository, user)
        expect(pull_requests).not_to be_empty
        expect(pull_requests).to all(be_instance_of(Github::PullRequest))
      end
    end

    context '該当する PullRequest がない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/pull_request/assigned_by_not_found' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'not_exist_user')

        pull_requests = Github::PullRequest.assigned_by(repository, user)
        expect(pull_requests).to be_empty
      end
    end
  end

  describe '.reviewed_by' do
    context '該当する PullRequest がある場合' do
      it 'Github::PullRequest オブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/pull_request/reviewed_by' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b')

        pull_requests = Github::PullRequest.reviewed_by(repository, user)
        expect(pull_requests).not_to be_empty
        expect(pull_requests).to all(be_instance_of(Github::PullRequest))
      end
    end

    context '該当する PullRequest がない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/pull_request/reviewed_by_not_found' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'not_exist_user')

        pull_requests = Github::PullRequest.reviewed_by(repository, user)
        expect(pull_requests).to be_empty
      end
    end
  end
end
