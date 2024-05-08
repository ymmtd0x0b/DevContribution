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

      exist_resolutions = user.assigned_issues.flat_map(&:resolutions)
      Resolution.synchronize(issues, pull_requests, exist_resolutions)
    end
  end
end
