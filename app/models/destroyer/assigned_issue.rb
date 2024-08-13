# frozen_string_literal: true

module Destroyer
  class AssignedIssue
    include Searchable

    def call(user)
      issues_id_referenced_by_other_users =
        user.assigned_issues.too_other_user.ids +
        user.assigned_issues.resolved_pull_requests_assigned_other_user.ids +
        user.assigned_issues.resolved_pull_requests_reviewed_other_user.ids +
        user.assigned_issues.by_other_author.ids

      user.assigned_issues.where.not(id: issues_id_referenced_by_other_users.uniq).destroy_all
    end
  end
end
