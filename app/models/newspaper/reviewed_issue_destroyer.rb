# frozen_string_literal: true

module Newspaper
  class ReviewedIssueDestroyer
    def call(user)
      destroy_reviewed_issues_not_referenced_by_other_users(user)
      destory_reviewed_pull_requests_not_referenced_by_other_users(user)
    end

    private

    def destroy_reviewed_issues_not_referenced_by_other_users(user)
      issues_id = user.reviewed_issues.ids
      issues_id_referenced_by_other_users = Issue.joins(:reviews, :assigns)
        .where('reviews.reviewable_id in (?) and reviews.user_id != ? or assigns.assignable_id in (?)', issues_id, user.id, issues_id)
        .ids

      user.reviewed_issues.where.not(id: issues_id_referenced_by_other_users).destroy_all
    end

    def destory_reviewed_pull_requests_not_referenced_by_other_users(user)
      pull_requests_id = user.reviewed_pull_requests.ids
      pull_requests_id_referenced_by_other_users = PullRequest.joins(:reviews, :assigns)
        .where('reviews.reviewable_id in (?) and reviews.user_id != ? or assigns.assignable_id in (?)', pull_requests_id, user.id, pull_requests_id)
        .ids

      user.reviewed_pull_requests.where.not(id: pull_requests_id_referenced_by_other_users).destroy_all
    end
  end
end
