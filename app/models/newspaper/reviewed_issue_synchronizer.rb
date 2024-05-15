# frozen_string_literal: true

module Newspaper
  class ReviewedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      pull_requests = Github::PullRequest.reviewed_by(repository, user)

      issues_number = pull_requests.flat_map(&:issues_number)
      issues = Github::Issue.search_numbers(repository, issues_number)

      Synchronizer.issues(issues)
      Synchronizer.pull_requests(pull_requests)
      Synchronizer.reviews(pull_requests, user)
      Synchronizer.resolutions(issues, pull_requests)
    end
  end
end
