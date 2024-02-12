module Github
  class Repository
    class << self
      def find_by(id = nil)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
        client.repo(id.to_i)
      end

      def hash_list_of_not_registed_by(user)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        unregisted_repository_name_list =
          all_involved_repository_name_list_by(user) - user.registed_repositories.pluck(:name)

        unregisted_repository_name_list.map do |repository_name|
          repository = client.repo(repository_name)

          { id: repository.id,
            name: repository.full_name,
            description: repository.description,
            avatar: repository.owner.avatar_url }
        end
      end

      def created_issues(user, repository)
        issues = search_issues("repo:#{repository.name} is:issue author:#{user.name}")
        issues.map { |issue| Github::Issue.new(issue, repository) }
      end

      def created_pull_requests(user, repository)
        pull_requests = search_issues("repo:#{repository.name} is:pr author:#{user.name}")
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end

      def issues_by_number(repository, issue_numbers)
        issues = issues(repository, issue_numbers)
        issues.map { |issue| Github::Issue.new(issue, repository) }
      end

      def reviewed_pull_requests(user, repository)
        pull_requests = search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.name} review:approved -assignee:#{user.name}")
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end

      private

      def all_involved_repository_name_list_by(user)
        issues = []
        issues.concat self.involved_issues_by(user)
        issues.concat self.involved_pull_requests_by(user)

        issues.flatten.map { |issue| issue.repository_name }
                      .uniq
      end

      def involved_issues_by(user)
        issues = search_issues("is:issue involves:#{user.name}")
        issues.map { |issue| Github::Issue.new(issue) }
      end

      def involved_pull_requests_by(user)
        issues = search_issues("is:pr involves:#{user.name}")
        issues.map { |issue| Github::Issue.new(issue) }
      end

      def search_issues(query, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        issues = []
        begin
          issues_per_page = client.search_issues(query, option)
          issues.concat issues_per_page.items
          option[:page] += 1
        end while(issues_per_page.items.count == option[:per_page])

        issues
      end

      def issues(repository, issue_numbers)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        issues = []
        issue_numbers.each_slice(50) do |numbers| # クエリの文字数制限(256 文字超 (演算子や修飾子は除く))を超えないように何回かに分けて処理を行う
          issues.concat client.search_issues("repo:#{repository.name} is:issue #{numbers.join(' ')}").items
        end

        issues
      end
    end
  end
end
