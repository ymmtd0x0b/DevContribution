# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Issue, type: :model do
  describe '#to_h' do
    it '自身をハッシュ(連想配列)へ変換して返すこと( labels_id は含まない )' do
      issue_data = { id: 111, user_id: 222, title: 'bug fix', number: 333, labels_id: [444, 555] }
      issue = Github::Issue.new(repository_id: 123, issue: issue_data)

      expect(issue.to_h).to eq({ id: 111, repository_id: 123, user_id: 222, title: 'bug fix', number: 333 })
    end
  end

  describe '#create_labelings' do
    it 'Issue と Label の ID をハッシュとして要素に持つ Array で返すこと' do
      issue_data = { id: 111, user_id: 222, title: 'bug fix', number: 333, labels_id: [444, 555] }
      issue = Github::Issue.new(repository_id: 123, issue: issue_data)

      expect(issue.create_labelings).to eq([{ issue_id: 111, label_id: 444 },
                                            { issue_id: 111, label_id: 555 }])
    end
  end

  describe '.created_by' do
    context '該当する Issue を取得できた場合' do
      it ' Github::Issue オブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/issue/created_by' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b')

        issues = Github::Issue.created_by(repository, user)
        expect(issues).to all(be_instance_of(Github::Issue))
      end
    end

    context '該当する Issue を取得できない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/issue/created_by_not_found' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'not_exist_user')

        issues = Github::Issue.created_by(repository, user)
        expect(issues).to be_empty
      end
    end
  end

  describe '.assigned_by' do
    context '該当する Issue を取得できた場合' do
      it ' Github::Issue オブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/issue/assigned_by' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b')

        issues = Github::Issue.assigned_by(repository, user)
        expect(issues).to all(be_instance_of(Github::Issue))
      end
    end

    context '該当する Issue を取得できない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/issue/assigned_by_not_found' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        user = FactoryBot.create(:user, login: 'not_exist_user')

        issues = Github::Issue.assigned_by(repository, user)
        expect(issues).to be_empty
      end
    end
  end

  describe '.search_numbers' do
    context '該当する Issue を取得できた場合' do
      it ' Github::Issue オブジェクトを要素に持つ Array を返すこと', vcr: { cassette_name: 'github/issue/search_numbers' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        issue_numbers = [1, 2]

        issues = Github::Issue.search_numbers(repository, issue_numbers)
        expect(issues).to all(be_instance_of(Github::Issue))
      end
    end

    context '該当する Issue を取得できない場合' do
      it '空の Array を返すこと', vcr: { cassette_name: 'github/issue/search_numbers_not_found' } do
        repository = FactoryBot.create(:repository, name: 'ymmtd0x0b/for_test2')
        issue_numbers = [123_45]

        issues = Github::Issue.search_numbers(repository, issue_numbers)
        expect(issues).to be_empty
      end
    end
  end
end
