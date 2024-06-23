# frozen_string_literal: true

module Destroyer
  class AssignedPullRequest
    def call(user)
      pull_requests_id = user.assigned_pull_requests.ids
      pull_requests_id_referenced_by_other_users =
        filter_pull_requests_assigned_by_other_users_from(pull_requests_id, user.id) +
        filter_pull_requests_reviewed_by_other_users_from(pull_requests_id, user.id)

      user.assigned_pull_requests.where.not(id: pull_requests_id_referenced_by_other_users).destroy_all
    end

    private

    def filter_pull_requests_assigned_by_other_users_from(pull_requests_id, user_id)
      PullRequest.joins(:assigns).where('pull_requests.id in (?) and assigns.user_id != ?', pull_requests_id, user_id).ids
    end

    def filter_pull_requests_reviewed_by_other_users_from(pull_requests_id, user_id)
      PullRequest.joins(:reviews).where('pull_requests.id in (?) and reviews.user_id != ?', pull_requests_id, user_id).ids
    end
  end
end
