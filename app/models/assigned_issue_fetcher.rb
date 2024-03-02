class AssignedIssueFetcher
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    issues = Github::Issue.assigned_by(repository, user)
    return nil if issues.empty?

    pull_requests = Github::PullRequest.assigned_by(repository, user)

    Upsert.issue(issues)
    Upsert.assign(issues, user)
    Upsert.pull_request(pull_requests)
    Upsert.solution(issues, pull_requests)
  end
end
