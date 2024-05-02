# frozen_string_literal: true

module Newspaper
  class AssignedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      Issue.synchronize(issues, with_labeling: true)
      Assign.synchronize('Issue', issues, user)

      pull_requests = Github::PullRequest.assigned_by(repository, user)
      PullRequest.synchronize(pull_requests)
      Assign.synchronize('PullRequest', pull_requests, user)
    end
  end
end
