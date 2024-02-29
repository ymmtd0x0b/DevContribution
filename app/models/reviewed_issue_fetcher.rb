class ReviewedIssueFetcher
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    pull_requests = Github::PullRequest.reviewed_by(repository, user)
    return nil if pull_requests.empty?

    issue_numbers = pull_requests.map { |pull_request| pull_request.reference_issue_numbers }.flatten
    issues = Github::Issue.search_numbers(repository, issue_numbers)

    Upsert.issue(issues)
    Upsert.review(issues, user)
    Upsert.pull_request(pull_requests)
    Upsert.reference(issues, pull_requests)
  end
end
