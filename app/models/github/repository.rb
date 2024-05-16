# frozen_string_literal: true

module Github
  class Repository
    attr_reader :id, :name, :url, :avatar_url

    def initialize(repository_data)
      @id = repository_data.id
      @name = repository_data.full_name
      @url = repository_data.html_url
      @avatar_url = repository_data.owner.avatar_url
    end

    def to_h
      { id: @id,
        name: @name,
        url: @url,
        avatar_url: @avatar_url }
    end

    class << self
      def find_by(id: nil, name: nil)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
        repository_data = id ? client.repo(id.to_i) : client.repo(name)
        new(repository_data)
      rescue Octokit::Error => e
        log_error(e)
        nil
      end

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

      def issues_by_number(repository, issue_numbers)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
        client.search_issues("repo:#{repository.name} is:issue #{issue_numbers.join(' ')}").items
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
