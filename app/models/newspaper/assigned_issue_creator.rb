module Newspaper
  class AssignedIssueCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      return nil if issues.empty?

      pull_requests = Github::PullRequest.assigned_by(repository, user)

      Upsert.issue(issues)
      Upsert.assign_to_issue(issues, user)

      Upsert.labeling(issues)

      Upsert.pull_request(pull_requests)
      Upsert.assign_to_pull_request(pull_requests, user)
    end
  end
end
