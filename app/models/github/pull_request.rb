# frozen_string_literal: true

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
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr assignee:#{user.login} -label:release")
        pull_requests.map { |pull_request| Github::PullRequest.new(repository.id, pull_request) }
      end

      def reviewed_by(repository, user)
        # pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.login} review:approved -assignee:#{user.login}")
        pull_requests = Github::Repository.search_issues("repo:#{repository.name} is:pr user-review-requested:#{user.login} -assignee:#{user.login}")
        pull_requests.map { |pull_request| Github::PullRequest.new(repository.id, pull_request) }
      end
    end

    private

    def scan_issue_numbers(body)
      issue_section = body.slice(/# [Ii]ssue.+# 概要/m)
      return nil if issue_section.blank?

      issue_urls = issue_section.scan(%r{http.+/issues/\d+|#\d+})
      issue_urls.map { |issue_url| issue_url.slice(/\d+$/) }.uniq
    end
  end
end
