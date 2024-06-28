# frozen_string_literal: true

module Destroyer
  class AssignedPullRequest
    include Searchable

    def call(user)
      pull_requests_id = user.assigned_pull_requests.ids
      pull_requests_id_referenced_by_other_users =
        filter_pull_requests_assigned_by_other_users_from(pull_requests_id, user.id) +
        filter_pull_requests_reviewed_by_other_users_from(pull_requests_id, user.id)

      user.assigned_pull_requests.where.not(id: pull_requests_id_referenced_by_other_users).destroy_all
    end
  end
end
