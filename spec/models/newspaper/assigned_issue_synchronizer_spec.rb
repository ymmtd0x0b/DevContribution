# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Newspaper::AssignedIssueSynchronizer, type: :model do
  before do
    VCR.use_cassette('newspaper/repository') do
      repo_data = Github::Repository.find_by(name: 'ymmtd0x0b/for_test2')
      @repository = Repository.create!(repo_data.to_h)
    end

    VCR.use_cassette('newspaper/labels') do
      labels = Github::Label.registered_by(@repository)
      labels.each { |label| Label.create!(label.to_h) }
    end

    @env_reposiory_id = ENV['FJORD_BOOTCAMP_REPOSITORY_ID']
    ENV['FJORD_BOOTCAMP_REPOSITORY_ID'] = @repository.id.to_s
  end

  after do
    ENV['FJORD_BOOTCAMP_REPOSITORY_ID'] = @env_repository_id
  end

  describe '#call', vcr: { cassette_name: 'newspaper/assigned_issue_synchronizer/call' } do
    context '取得した Issue が未だ登録されていない場合' do
      it '新規登録すること' do
        user = FactoryBot.create(:user, login: 'ymmtd0x0b')
        expect { Newspaper::AssignedIssueSynchronizer.new.call(user) }.to change { user.assigned_issues.count }.from(0).to(3)
      end
    end

    context '取得した Issue が既に登録されている場合' do
      it '対象を更新すること' do
        issue = FactoryBot.create(:issue, id: 208_016_096_8, title: '同期処理により更新されるタイトル')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b') { |created_user| created_user.assigned_issues << issue }

        expect do
          Newspaper::AssignedIssueSynchronizer.new.call(user)
          issue.reload
        end.to change { issue.title }.from('同期処理により更新されるタイトル').to('issue_01')
      end
    end

    context '登録済みの Issue が、取得した Issue に含まれない場合' do
      it 'アソシエーションを削除すること' do
        issue = FactoryBot.create(:issue, id: 1, title: '同期処理によりアソシエーションを削除される')
        user = FactoryBot.create(:user, login: 'ymmtd0x0b') { |created_user| created_user.assigned_issues << issue }

        expect do
          Newspaper::AssignedIssueSynchronizer.new.call(user)
          user.reload
        end.to change { user.assigned_issues }.from(include(issue)).to(exclude(issue))
      end
    end
  end
end
