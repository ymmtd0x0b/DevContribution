module Newspaper
  class AssignedIssueDestroyer
    def call(user)
      destroy_assigned_issues(user)
      destory_assigned_pull_requests(user)
    end

    private

    def destroy_assigned_issues(user)
      issues_with_other_users, issues_without_other_users =
        user.assigned_issues.partition do |issue|
          issue.reviewers.exists? or issue.assignees.where.not(id: user.id).exists?
        end

      if issues_with_other_users.any?
        issues_id = issues_with_other_users.map(&:id)
        # Assign.where('assignable_id in (?) and user_id = ?', issues_id, user.id).destroy_all
        user.assigns.where(assignable_type: 'Issue', assignable_id: issues_id).destroy_all
      end

      if issues_without_other_users.any?
        issues_id = issues_without_other_users.map(&:id)
        # Issue.where(id: issues_id).destroy_all
        user.assigned_issues.where(id: issues_id).destroy_all
      end
    end

    def destory_assigned_pull_requests(user)
      pull_requests_with_other_users, pull_requests_without_other_users =
        user.assigned_pull_requests.partition do |pull_request|
          pull_request.reviewers.exists? or pull_request.assignees.where.not(id: user.id).exists?
        end

      if pull_requests_with_other_users.any?
        pull_requests_id = pull_requests_with_other_users.map(&:id)
        # Assign.where('assignable_id in (?) and user_id = ?', pull_requests_id, user.id).destroy_all
        user.assigns.where(assignable_type: 'PullRequest', assignable_id: pull_requests_id).destroy_all
      end

      if pull_requests_without_other_users.any?
        pull_requests_id = pull_requests_without_other_users.map(&:id)
        # PullRequest.where(id: pull_requests_id).destroy_all
        user.assigned_pull_requests.where(id: pull_requests_id).destroy_all
      end
    end
  end
end
