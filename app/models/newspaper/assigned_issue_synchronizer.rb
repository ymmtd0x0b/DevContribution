# frozen_string_literal: true

module Newspaper
  class AssignedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      pull_requests = Github::PullRequest.assigned_by(repository, user)

      Synchronizer.issues(issues)
      Synchronizer.assigns('Issue', issues, user)

      Synchronizer.pull_requests(pull_requests)
      Synchronizer.assigns('PullRequest', pull_requests, user)

      Synchronizer.resolutions(issues, pull_requests)
    end
  end
end
