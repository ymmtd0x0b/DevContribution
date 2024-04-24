# frozen_string_literal: true

module Newspaper
  class ReviewedIssueCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      pull_requests = Github::PullRequest.reviewed_by(repository, user)

      issue_numbers = []
      pull_requests.each do |pull_request|
        issue_numbers.concat pull_request.issue_numbers
      end
      issues = Github::Issue.search_numbers(repository, issue_numbers)

      Issue.bulk_insert(issues)
      Labeling.bulk_insert(issues)
      Review.bulk_insert('Issue', issues, user)

      PullRequest.bulk_insert(pull_requests)
      Review.bulk_insert('PullRequest', pull_requests, user)
    end
  end
end
