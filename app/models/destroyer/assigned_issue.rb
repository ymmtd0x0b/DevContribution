# frozen_string_literal: true

module Destroyer
  class AssignedIssue
    def call(user)
      issues_id = user.assigned_issues.ids
      issues_id_referenced_by_other_users =
        filter_issues_assigned_by_other_users_from(issues_id, user.id) +
        filter_issues_referring_pull_requests_assigned_by_other_users_from(issues_id, user.id) +
        filter_issues_referring_pull_requests_reviewed_by_other_users_from(issues_id, user.id) +
        filter_issues_created_by_other_users_that_exist_in_database_from(issues_id, user.id)

      user.assigned_issues.where.not(id: issues_id_referenced_by_other_users).destroy_all
    end

    private

    def filter_issues_assigned_by_other_users_from(issues_id, user_id)
      Issue.joins(:assigns).where(id: issues_id).where('assigns.user_id != ?', user_id).ids
    end

    def filter_issues_referring_pull_requests_assigned_by_other_users_from(issues_id, user_id)
      Issue.joins(pull_requests: :assigns)
           .where(id: issues_id)
           .where('assigns.assignable_type = ? AND assigns.user_id != ?', 'PullRequest', user_id)
           .ids
    end

    def filter_issues_referring_pull_requests_reviewed_by_other_users_from(issues_id, user_id)
      Issue.joins(pull_requests: :reviews)
           .where(id: issues_id)
           .where('reviews.user_id != ?', user_id)
           .ids
    end

    def filter_issues_created_by_other_users_that_exist_in_database_from(issues_id, user_id)
      Issue.joins(:user).where(id: issues_id).where('issues.user_id != ?', user_id).ids
    end
  end
end
