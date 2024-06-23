# frozen_string_literal: true

module Destroyer
  class ReviewedIssue
    def call(user)
      destory_reviewed_pull_requests_not_referenced_by_other_users(user)
    end

    private

    def destory_reviewed_pull_requests_not_referenced_by_other_users(user)
      pull_requests_id = user.reviewed_pull_requests.ids
      pull_requests_id_referenced_by_other_users =
        PullRequest.joins(:reviews, :assigns)
                   .where('reviews.reviewable_id in (?) and reviews.user_id != ? or assigns.assignable_id in (?)', pull_requests_id, user.id, pull_requests_id)
                   .ids

      user.reviewed_pull_requests.where.not(id: pull_requests_id_referenced_by_other_users).destroy_all
    end
  end
end
