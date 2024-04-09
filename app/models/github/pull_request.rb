module Github
  class PullRequest
    attr_reader :id

    def initialize(pull_request, repository)
      @id = pull_request.id
      @repository_id = repository.id
      @url = pull_request.html_url
      @user_id = pull_request.user.id

      @body = pull_request.body
    end

    class << self
      def assigned_by(repository, user)
        # pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr assignee:#{user.login} -label:release is:merged")
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr assignee:#{user.login} -label:release") # 確認用
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end

      def reviewed_by(repository, user)
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.login} review:approved -assignee:#{user.login} is:merged")
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end
    end

    def to_activerecord_attributes
      { id: @id,
        repository_id: @repository_id,
        url: @url,
        user_id: @user_id }
    end

    def solutions_issue_numbers
      @issue_numbers ||= scan_issue_urls.map { |issue_url| issue_url.slice(/\d+$/) }.uniq
    end

    def to_association_of_solutions(issues)
      solutions_issue_numbers.filter_map do |issue_number|
        issue = issues.find { |issue| issue.number == issue_number.to_i }
        next if issue.nil?

        { issue_id: issue.id, pull_request_id: @id }
      end
    end

    private

    def scan_issue_urls
      return [] if (@body.nil? or !@body.match?(/# [Ii]ssue.+# 概要/m))

      issue_section = @body.slice(/# [Ii]ssue.+# 概要/m)
      return [] if issue_section.nil?

      issue_section.scan(/http.+\/issues\/\d+|#\d+/)
    end
  end
end
