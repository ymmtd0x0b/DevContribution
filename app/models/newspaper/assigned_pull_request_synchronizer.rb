# frozen_string_literal: true

module Newspaper
  class AssignedPullRequestSynchronizer
    def call(payload)
      repository = payload[:repository]
      user = payload[:user]

      pull_requests = Github::PullRequest.assigned_by(repository, user)
      PullRequest.synchronize(pull_requests)
      Assign.syncrhonize('PullRequest', pull_requests, user)
      Synchronizer.synchronize_resolutions(pull_requests)
    end
  end
end
