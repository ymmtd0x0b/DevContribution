# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wiki, type: :model do
  describe '.synchronize' do
    before do
      FactoryBot.create(:repository, id: 123)
      FactoryBot.create(:user, id: 456)
    end

    context '引数に渡されたデータの中に「未登録の Wiki」がある場合' do
      it '新たに登録すること' do
        FactoryBot.create(:wiki, :with_repository, :with_user, repository_id: 123, user_id: 456, title: 'Wiki#1', first_commit_hash: 'aaa')

        expect do
          current = Time.zone.now
          wikis_collected_by_the_github_api = [
            Git::Wiki.new(repository_id: 123, file_data: { user_id: 456, title: 'Wiki#1', first_commit_hash: 'aaa', created_at: current, updated_at: current }),
            Git::Wiki.new(repository_id: 123, file_data: { user_id: 456, title: 'Wiki#2', first_commit_hash: 'bbb', created_at: current, updated_at: current })
          ]
          user = User.find(456)
          Wiki.synchronize(user, wikis_collected_by_the_github_api)
        end.to change { Wiki.all.pluck(:title) }.from(['Wiki#1']).to(['Wiki#1', 'Wiki#2'])
      end
    end

    context '引数に渡されたデータの中に「登録済みの Wiki」がある場合' do
      it '該当 Wiki の情報を更新すること' do
        wiki = FactoryBot.create(:wiki, :with_repository, :with_user, repository_id: 123, user_id: 456, title: 'before update...', first_commit_hash: 'aaa')

        expect do
          current = Time.zone.now
          wikis_collected_by_the_github_api = [
            Git::Wiki.new(repository_id: 123,
                          file_data: { user_id: 456, title: 'updated!', first_commit_hash: 'aaa', created_at: current, updated_at: current })
          ]
          user = User.find(456)
          Wiki.synchronize(user, wikis_collected_by_the_github_api)
        end.to change { wiki.reload.title }.from('before update...').to('updated!')
      end
    end

    context '登録済みの Wiki が引数に渡されたデータの中に存在しない場合' do
      it '該当 Wiki のデータを削除すること' do
        FactoryBot.create(:wiki, :with_repository, :with_user, repository_id: 123, user_id: 456, title: 'Wiki#100', first_commit_hash: 'aaa')
        FactoryBot.create(:wiki, :with_repository, :with_user, repository_id: 123, user_id: 456, title: 'Wiki#200', first_commit_hash: 'bbb')

        expect do
          current = Time.zone.now
          wikis_collected_by_the_github_api = [
            Git::Wiki.new(repository_id: 123,
                          file_data: { user_id: 456, title: 'Wiki#100', first_commit_hash: 'aaa', created_at: current, updated_at: current })
          ]
          user = User.find(456)
          Wiki.synchronize(user, wikis_collected_by_the_github_api)
        end.to change { Wiki.all.pluck(:title) }.from(['Wiki#100', 'Wiki#200']).to(['Wiki#100'])
      end
    end
  end
end
