# frozen_string_literal: true

module Newspaper
  class AssignedIssueCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      Issue.bulk_insert(issues)
      Labeling.bulk_insert(issues)
      Assign.bulk_insert('Issue', issues, user)

      pull_requests = Github::PullRequest.assigned_by(repository, user)
      PullRequest.bulk_insert(pull_requests)
      Assign.bulk_insert('PullRequest', pull_requests, user)
    end
  end
end
