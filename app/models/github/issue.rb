# frozen_string_literal: true

module Github
  class Issue
    attr_reader :id, :number

    def initialize(repository_id, issue)
      @id = issue.id
      @repository_id = repository_id
      @user_id = issue.user.id
      @title = issue.title
      @number = issue.html_url.slice(/\d+$/).to_i
      @labels_id = issue.labels.map(&:id)
    end

    def to_h
      { id: @id,
        repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        number: @number }
    end

    def labeling_of_hash_list
      @labels_id.map { |label_id| { issue_id: @id, label_id: } }
    end

    class << self
      def created_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue author:#{user.login}")
        issues.map { |issue| new(repository.id, issue) }
      end

      def assigned_by(repository, user)
        issues = Github::Repository.search_issues("repo:#{repository.name} is:issue assignee:#{user.login}")
        issues.map { |issue| new(repository.id, issue) }
      end

      def search_numbers(repository, numbers)
        return [] if numbers.empty?

        issues = Github::Repository.issues_by_number(repository, numbers)
        issues.map { |issue| new(repository.id, issue) }
      end
    end
  end
end
