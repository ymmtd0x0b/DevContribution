class ReviewedPullRequestUpdater
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    pull_requests = Github::PullRequest.reviewed_by(repository, user)
    return nil if pull_requests.empty?

    issue_numbers = pull_requests.map { |pull_request| pull_request.reference_issue_numbers }.flatten
    issues = Github::Issue.search_numbers(repository, issue_numbers)

    Upsert.pull_request(pull_requests)
    Upsert.issue(issues)
    Upsert.reference(pull_requests, issues)
    Upsert.review(pull_requests, user)
  end
end
