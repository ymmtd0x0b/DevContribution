class AssignedPullRequestCreator
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    pull_requests = Github::PullRequest.created_by(repository, user)
    return nil if pull_requests.empty?

    issue_numbers = pull_requests.map { |pull_request| pull_request.reference_issue_numbers }.flatten
    issues = Github::Issue.search_numbers(repository, issue_numbers)

    Insert.pull_request(pull_requests)
    Insert.issue(issues)
    Insert.reference(pull_requests, issues)
    Insert.assign(pull_requests, user)
  end
end
