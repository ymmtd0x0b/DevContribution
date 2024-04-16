module Github
  class PullRequest
    attr_reader :id, :issue_numbers

    def initialize(repository_id, pull_request)
      @id = pull_request.id
      @repository_id = repository_id
      @number = pull_request.number
      @issue_numbers = scan_issue_numbers(pull_request.body)
    end

    def to_h
      { id: @id,
        repository_id: @repository_id,
        number: @number,
        issue_numbers: @issue_numbers }
    end

    class << self
      def assigned_by(repository, user)
        # pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr assignee:#{user.login} -label:release is:merged")
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr assignee:#{user.login} -label:release") # 確認用
        pull_requests.map { |pull_request| Github::PullRequest.new(repository.id, pull_request) }
      end

      def reviewed_by(repository, user)
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.login} review:approved -assignee:#{user.login} is:merged")
        pull_requests.map { |pull_request| Github::PullRequest.new(repository.id, pull_request) }
      end
    end

    private

    def scan_issue_numbers(body)
      return [] if (body.nil? or !body.match?(/# [Ii]ssue.+# 概要/m))

      issue_section = body.slice(/# [Ii]ssue.+# 概要/m)
      return [] if issue_section.nil?

      issue_urls = issue_section.scan(/http.+\/issues\/\d+|#\d+/)
      issue_urls.map { |issue_url| issue_url.slice(/\d+$/) }.uniq
    end
  end
end
