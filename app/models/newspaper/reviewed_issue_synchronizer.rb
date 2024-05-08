# frozen_string_literal: true

module Newspaper
  class ReviewedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      pull_requests = Github::PullRequest.reviewed_by(repository, user)

      issues_number = []
      pull_requests.each do |pull_request|
        issues_number.concat pull_request.issues_number
      end
      issues = Github::Issue.search_numbers(repository, issues_number)

      Issue.synchronize(issues, with_labeling: true)
      Review.synchronize('Issue', issues, user)

      PullRequest.synchronize(pull_requests)
      Review.synchronize('PullRequest', pull_requests, user)

      exist_resolutions = user.reviewed_issues.flat_map(&:resolutions)
      Resolution.synchronize(issues, pull_requests, exist_resolutions)
    end
  end
end
