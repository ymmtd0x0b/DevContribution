module Github
  class Issue
    attr_reader :id

    def initialize(repository, issue)
      @id = issue.id
      @repository_id = repository.id
      @user_id = issue.user.id
      @title = issue.title
      @url = issue.html_url
      @created_at = issue.created_at
      @updated_at = issue.updated_at
      @labels = issue.labels
    end

    def number
      @url.slice(/\d+$/).to_i
    end

    def labels_id
      return [] if @labels.nil?

      @labels.map(&:id)
    end

    def to_activerecord_attributes
      { id: @id,
        repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        url: @url,
        created_at: @created_at,
        updated_at: @updated_at }
    end

    def to_association_of_labels
      @labels.map { |label| { label_id: label.id, issue_id: @id } }
    end

    class << self
      def created_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue author:#{user.login}")
        issues.map { |issue| Github::Issue.new(repository, issue) }
      end

      def assigned_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue assignee:#{user.login}")
        issues.map { |issue| Github::Issue.new(repository, issue) }
      end

      def search_numbers(repository, numbers)
        issues = Github::Repository.issues_by_number(repository, numbers)
        issues.map { |issue| Github::Issue.new(repository, issue) }
      end
    end
  end
end
