# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Git::Wiki, type: :model do
  describe '#to_h' do
    it '自身をハッシュ(連想配列)へ変換して返すこと' do
      wiki = Git::Wiki.new(repository_id: 123, file_data: { user_id: 111,
                                                            title: '議事録',
                                                            first_commit_hash: 'abcdefg',
                                                            created_at: '2024-03-03',
                                                            updated_at: '2024-04-04' })

      expect(wiki.to_h).to eq({ repository_id: 123,
                                user_id: 111,
                                title: '議事録',
                                first_commit_hash: 'abcdefg',
                                created_at: '2024-03-03',
                                updated_at: '2024-04-04' })
    end
  end

  describe '.created_by' do
    before do
      tmpdir = Dir.mktmpdir
      @tmpdir_realpath = File.realpath tmpdir

      Dir.chdir(@tmpdir_realpath) do
        git = Git.init('test_repository.wiki.git')

        git.config('user.name', 'alice')
        git.config('user.email', 'alice@example.com')

        File.write('test_repository.wiki.git/test.txt', 'test')
        git.add('test.txt')
        git.commit('first commit')
      end
    end

    after do
      FileUtils.remove_entry_secure @tmpdir_realpath
    end

    context '該当する Wiki がある場合' do
      it 'Git::Wiki オブジェクトを要素に持つ Array を返すこと' do
        Dir.chdir(@tmpdir_realpath) do
          repository = FactoryBot.create(:repository, url: 'test_repository')
          user = FactoryBot.create(:user, login: 'alice')

          wikis = Git::Wiki.created_by(repository, user)
          expect(wikis).not_to be_empty
          expect(wikis).to all(be_instance_of(Git::Wiki))
        end
      end
    end

    context '該当する Wiki がない場合' do
      it '空の Array を返すこと' do
        Dir.chdir(@tmpdir_realpath) do
          repository = FactoryBot.create(:repository, url: 'test_repository')
          user = FactoryBot.create(:user, login: 'bob')

          wikis = Git::Wiki.created_by(repository, user)
          expect(wikis).to be_empty
        end
      end
    end

    context 'エラーが発生した場合' do
      before do
        @repository = FactoryBot.create(:repository, url: 'not_exist_repository')
        @user = FactoryBot.create(:user, login: 'alice')
      end

      it '空の Array を返すこと' do
        Dir.chdir(@tmpdir_realpath) do
          wikis = Git::Wiki.created_by(@repository, @user)
          expect(wikis).to be_empty
        end
      end

      it 'ログに出力すること' do
        Dir.chdir(@tmpdir_realpath) do
          expect(Rails.logger).to receive(:error).with("[Git] fatal: リポジトリ 'not_exist_repository.wiki.git' は存在しません")
          Git::Wiki.created_by(@repository, @user)
        end
      end
    end
  end
end
