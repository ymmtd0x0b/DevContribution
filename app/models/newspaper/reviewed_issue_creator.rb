module Newspaper
  class ReviewedIssueCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      pull_requests = Github::PullRequest.reviewed_by(repository, user)
      return nil if pull_requests.empty?

      issue_numbers = []
      pull_requests.each do |pull_request|
        issue_numbers.concat pull_request.issue_numbers
      end
      issues = Github::Issue.search_numbers(repository, issue_numbers)

      Upsert.issue(issues)
      Upsert.review_to_issue(issues, user)

      Upsert.labeling(issues)

      Upsert.pull_request(pull_requests)
      Upsert.review_to_pull_request(pull_requests, user)
    end
  end
end
