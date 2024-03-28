module Newspaper
  class AssignedIssueDestroyer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      destroy_assigned_issues(user)
      destory_assigned_pull_requests(user)
    end

    def destroy_assigned_issues(user)
      issues_with_reviewer, issues_without_reviewer =
        user.assigned_issues.partition { |issue| issue.reviewers.exists? }

      issue_ids = issues_with_reviewer.map(&:id)
      Assign.where(assignable_id: issue_ids).destroy_all if issue_ids.any?

      issue_ids = issues_without_reviewer.map(&:id)
      Issue.where(id: issue_ids).destroy_all if issue_ids.any?
    end

    def destory_assigned_pull_requests(user)
      pull_requests_with_reviewer, pull_requests_without_reviewer =
        user.assigned_pull_requests.partition { |pull_request| pull_request.reviewers.exists? }

      pull_request_ids = pull_requests_with_reviewer.map(&:id)
      Assign.where(assignable_id: pull_request_ids).destroy_all if pull_request_ids.any?

      pull_request_ids = pull_requests_without_reviewer.map(&:id)
      PullRequest.where(id: pull_request_ids).destroy_all if pull_request_ids.any?
    end
  end
end
