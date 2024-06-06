# frozen_string_literal: true

module Newspaper
  class ReviewedIssueSynchronizer
    def call(payload)
      repository = payload[:repository]
      user = payload[:user]

      pull_requests = Github::PullRequest.reviewed_by(repository, user)

      issues_number = pull_requests.flat_map(&:issues_number)
      issues = Github::Issue.search_numbers(repository, issues_number)

      synchronize_issues(issues)
      synchronize_pull_requests(pull_requests)
      synchronize_reviews(pull_requests, user)
      synchronize_resolutions(issues, pull_requests)
    end

    private

    def synchronize_reviews(pull_requests, user)
      user.reviews.where.not(pull_request_id: pull_requests.map(&:id)).delete_all

      hash_list = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Review.insert_all(hash_list, unique_by: %i[user_id pull_request_id]) if hash_list.any?
    end
  end
end
