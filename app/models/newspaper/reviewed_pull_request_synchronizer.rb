# frozen_string_literal: true

module Newspaper
  class ReviewedPullRequestSynchronizer
    def call(payload)
      repository = payload[:repository]
      user = payload[:user]

      pull_requests = Github::PullRequest.reviewed_by(repository, user)
      PullRequest.synchronize(pull_requests)
      Review.synchronize(pull_requests, user)
      Synchronizer.synchronize_resolutions(issues, pull_requests)
    end
  end
end
