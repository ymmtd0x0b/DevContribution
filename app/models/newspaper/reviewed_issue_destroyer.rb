module Newspaper
  class ReviewedIssueDestroyer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      destroy_reviewed_issues(user)
      destory_reviewed_pull_requests(user)
    end

    def destroy_reviewed_issues(user)
      issues_with_assignee, issues_without_assignee =
        user.reviewed_issues.partition { |issue| issue.assignee.exists? }

      issue_ids = issues_with_assignee.map(&:id)
      Review.where(reviewable_id: issue_ids).destroy_all if issue_ids.any?

      issue_ids = issues_without_assignee.map(&:id)
      Issue.where(id: issue_ids).destroy_all if issue_ids.any?
    end

    def destory_reviewed_pull_requests(user)
      pull_requests_with_assignee, pull_requests_without_assignee =
        user.reviewed_pull_requests.partition { |pull_request| pull_request.assignee.exists? }

      pull_request_ids = pull_requests_with_assignee.map(&:id)
      Review.where(reviewable_id: pull_request_ids).destroy_all if pull_request_ids.any?

      pull_request_ids = pull_requests_without_assignee.map(&:id)
      PullRequest.where(id: pull_request_ids).destroy_all if pull_request_ids.any?
    end
  end
end
