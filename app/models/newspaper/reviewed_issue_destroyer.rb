module Newspaper
  class ReviewedIssueDestroyer
    def call(user)
      destroy_reviewed_issues(user)
      destory_reviewed_pull_requests(user)
    end

    private

    def destroy_reviewed_issues(user)
      issues_with_other_users, issues_without_other_users =
        user.reviewed_issues.partition do |issue|
          issue.assignees.exists? or issue.reviewers.where.not(id: user.id).exists?
        end

      if issues_with_other_users.any?
        issues_id = issues_with_other_users.map(&:id)
        # Review.where('reviewable_id in (?) and user_id = ?', issues_id, user.id).destroy_all
        user.reviews.where(reviewable_type: 'Issue', reviewable_id: issues_id).destroy_all
      end

      if issues_without_other_users.any?
        issues_id = issues_without_other_users.map(&:id)
        # Issue.where(id: issues_id).destroy_all
        user.reviewed_issues.where(id: issues_id).destroy_all
      end
    end

    def destory_reviewed_pull_requests(user)
      pull_requests_with_other_users, pull_requests_without_other_users =
        user.reviewed_pull_requests.partition do |pull_request|
          pull_request.assignees.exists? or pull_request.reviewers.where.not(id: user.id).exists?
        end

      if pull_requests_with_other_users.any?
        pull_requests_id = pull_requests_with_other_users.map(&:id)
        # Review.where('reviewable_id in (?) and user_id = ?', pull_requests_id, user.id).destroy_all
        user.reviews.where(reviewable_type: 'PullRequest', reviewable_id: pull_requests_id).destroy_all
      end

      if pull_requests_without_other_users.any?
        pull_requests_id = pull_requests_without_other_users.map(&:id)
        # PullRequest.where(id: pull_requests_id).destroy_all
        user.reviewed_pull_requests.where(id: pull_requests_id).destroy_all
      end
    end
  end
end
