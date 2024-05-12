# frozen_string_literal: true

module Git
  class Wiki
    attr_reader :first_commit_hash

    def initialize(repository, user, file_name, file_log)
      @repository_id = repository.id
      @user_id = user.id
      @title = file_name.delete_suffix('.md')
      @first_commit_hash = file_log.last.sha
      @created_at = file_log.last.author_date
      @updated_at = file_log.first.author_date
    end

    def to_h
      { repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        first_commit_hash: @first_commit_hash,
        created_at: @created_at,
        updated_at: @updated_at }
    end

    class << self
      def created_by(repository, user)
        Dir.mktmpdir do |dir|
          tmpdir_path = "#{dir}/#{repository.name}.wiki.git"

          Git.clone("https://github.com/#{repository.name}.wiki.git", tmpdir_path)

          git = Git.open tmpdir_path
          wikis = git.lib.ls_files

          wikis.filter_map do |file_name, _|
            file_log = git.log.object("#{tmpdir_path}/#{file_name}")
            Wiki.new(repository, user, file_name, file_log) if [user.login, user.name].include? file_log.last.author.name
          end
        rescue FailedError => e
          log_error(e)
          nil
        end
      end

      private

      def log_error(exception)
        # NOTE: exception の例
        #       - fatal: repository 'https://github.com/sample/repository.wiki.git/' not found
        #       - fatal: unable to access 'https://github.com/sample/repository.wiki.git/': Could not resolve host: github.com
        Rails.logger.error "[Git] #{exception.to_s.slice(/output: "(.+)"/, 1).split('\\n').last}"
      end
    end
  end
end
