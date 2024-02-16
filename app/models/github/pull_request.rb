module Github
  class PullRequest
    def initialize(pull_request, repository)
      @id = pull_request.id
      @repository_id = repository.id
      @url = pull_request.html_url

      @body = pull_request.body
    end

    class << self
      def created_by(repository, user)
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr author:#{user.name}")
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end

      def reviewed_by(repository, user)
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.name} review:approved -assignee:#{user.name}")
        pull_requests.map { |pull_request| Github::PullRequest.new(pull_request, repository) }
      end
    end

    def to_activerecord_attributes
      { id: @id,
        repository_id: @repository_id,
        url: @url }
    end

    def reference_issue_numbers
      @issue_numbers ||= scan_issue_urls.map { |issue_url| issue_url.slice(/\d+$/) }.uniq
    end

    def to_association_of_labels(issues)
      reference_issue_numbers.map do |issue_number|
        issue = issues.find { |issue| issue.number == issue_number.to_i }
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
