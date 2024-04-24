# frozen_string_literal: true

module Git
  class Wiki
    def initialize(repository, user, file_name, file_log)
      @repository_id = repository.id
      @user_id = user.id
      @title = file_name.delete_suffix('.md')
      @created_at = file_log.last.author_date
      @updated_at = file_log.first.author_date
    end

    def to_h
      { repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        created_at: @created_at,
        updated_at: @updated_at }
    end

    class << self
      def created_by(repository, user)
        Dir.mktmpdir do |dir|
          tmpdir_path = "#{dir}/#{repository.name}.wiki.git"

          response = begin
            Git.clone("https://github.com/#{repository.name}.wiki.git", tmpdir_path)
          rescue StandardError
            nil
          end
          return [] if response.nil?

          git = Git.open tmpdir_path
          wikis = git.lib.ls_files

          wikis.filter_map do |file_name, _|
            file_log = git.log.object("#{tmpdir_path}/#{file_name}")
            Wiki.new(repository, user, file_name, file_log) if [user.login, user.name].include? file_log.last.author.name
          end
        end
      end
    end
  end
end
