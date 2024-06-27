# frozen_string_literal: true

module Destroyer
  class ReviewedIssue
    include Searchable

    def call(user)
      issues_id = user.reviewed_issues.ids
      issues_id_referenced_by_other_users =
        filter_issues_assigned_by_other_users_from(issues_id, user.id) +
        filter_issues_referring_pull_requests_assigned_by_other_users_from(issues_id, user.id) +
        filter_issues_referring_pull_requests_reviewed_by_other_users_from(issues_id, user.id) +
        filter_issues_created_by_other_users_that_exist_in_database_from(issues_id, user.id)

      user.reviewed_issues.where.not(id: issues_id_referenced_by_other_users).destroy_all
    end
  end
end
