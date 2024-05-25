# frozen_string_literal: true

module Github
  class Issue
    attr_reader :id, :number, :labels_id

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

    def create_labelings
      @labels_id.map { |label_id| { issue_id: @id, label_id: } }
    end

    class << self
      def created_by(repository, user)
        issues = search_issues("repo:#{repository.name} is:issue author:#{user.login}")
        issues.map { |issue| new(repository.id, issue) }
      end

      def assigned_by(repository, user)
        issues = search_issues("repo:#{repository.name} is:issue assignee:#{user.login}")
        issues.map { |issue| new(repository.id, issue) }
      end

      def search_numbers(repository, numbers)
        issues = search_issues("repo:#{repository.name} is:issue #{issue_numbers.join(' ')}")
        issues.map { |issue| new(repository.id, issue) }
      end

      private

      def search_issues(query, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        issues = []
        loop do
          issues_per_page = client.search_issues(query, option)
          issues.concat issues_per_page.items
          option[:page] += 1
          break unless issues_per_page.items.count == option[:per_page]
        end

        issues
      rescue Octokit::Error => e
        log_error(e)
        []
      end

      def log_error(exception)
        # NOTE: exception の例
        #       - GET https://api.github.com/repos/ymmtd0x0b/error: 404 - Not Found // See: https://docs.github.com/rest/repos/repos#get-a-repository
        Rails.logger.error "[GitHub API] #{exception}"
      end
    end
  end
end
