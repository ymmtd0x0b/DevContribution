module Git
  class Wiki
    def initialize(file_name, file_log, repository_id, user_id)
      @repository_id = repository_id
      @user_id = user_id
      @title = file_name.delete_suffix('.md')
      @created_at = file_log.last.author_date
      @updated_at = file_log.first.author_date
    end

    def to_hash_of_activerecords_attributes
      {
        repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        created_at: @created_at,
        updated_at: @updated_at
      }
    end

    class << self
      def save_all(repository, user)
        Dir.mktmpdir do |dir|
          tmpdir_path = "#{dir}/#{repository.name}.wiki.git"

          response = Git.clone("https://github.com/#{repository.name}.wiki.git", tmpdir_path) rescue nil

          # Wikiページに関する API は現状実装されていないようなので
          # gitクローンでエラーが発生したら、Wikiページが存在しないと見做す
          return if response.nil?

          git = Git.open tmpdir_path

          # 直下の全てのファイルから作成者のユーザーを指定して抽出
          # ※Wikiページは直下のみで複雑な階層構造にはならないっぽい
          # (GitHub の Wikiページの UI にそのような機能が見当たらない)
          wikis = wikis_created_by(user, repository, tmpdir_path)
          wikis_data = wikis.map(&:to_hash_of_activerecords_attributes)
          ::Wiki.insert_all(wikis_data) if wikis_data.present?
        end
      end

      private

      def wikis_created_by(user, repository, tmpdir_path)
        git = Git.open tmpdir_path

        wikis =
          git.lib.ls_files.map do |file_name, _|
            file_log = git.log.object("#{tmpdir_path}/#{file_name}")
            Wiki.new(file_name, file_log, repository.id, user.id) if file_log.last.author.name == user.name # そのファイルの最初のコミッター == 作成者
          end

        wikis.compact
      end
    end
  end
end
