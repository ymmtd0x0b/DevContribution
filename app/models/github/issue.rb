module Github
  class Issue
    attr_reader :id

    def initialize(repository_id, issue)
      @id = issue.id
      @repository_id = repository_id
      @user_id = issue.user.id
      @title = issue.title
      @number = issue.html_url.slice(/\d+$/).to_i
      @labels_id = issue.labels.map(&:id)
      @created_at = issue.created_at
      @updated_at = issue.updated_at
    end

    def to_h
      { id: @id,
        repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        number: @number,
        labels_id: @labels_id,
        created_at: @created_at,
        updated_at: @updated_at }
    end
    class << self
      def created_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue author:#{user.login}")
        issues.map { |issue| Github::Issue.new(repository.id, issue) }
      end

      def assigned_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue assignee:#{user.login}")
        issues.map { |issue| Github::Issue.new(repository.id, issue) }
      end

      def search_numbers(repository, numbers)
        issues = Github::Repository.issues_by_number(repository, numbers)
        issues.map { |issue| Github::Issue.new(repository.id, issue) }
      end
    end
  end
end
