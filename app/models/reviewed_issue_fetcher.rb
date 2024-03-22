class ReviewedIssueFetcher
  def call(user)
    repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

    pull_requests = Github::PullRequest.reviewed_by(repository, user)
    return nil if pull_requests.empty?

    issue_numbers = pull_requests.map { |pull_request| pull_request.solutions_issue_numbers }.flatten
    issues = Github::Issue.search_numbers(repository, issue_numbers)

    Upsert.issue(issues)
    Upsert.review(issues, user)
    Upsert.pull_request(pull_requests)
    Upsert.solution(issues, pull_requests)
  end
end
