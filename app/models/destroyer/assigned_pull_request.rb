# frozen_string_literal: true

module Destroyer
  class AssignedIssue
    def call(user)
      destroy_assigned_issues_not_referenced_by_other_users(user)
      # destory_assigned_pull_requests_not_referenced_by_other_users(user)
    end

    private

    def destroy_assigned_issues_not_referenced_by_other_users(user)
      issues_id_referenced_by_other_users =
        issues_id_that_other_user_is_assigning_to(user) +
        issues_id_that_other_user_is_referring_to_through_assigns_pull_request(user) +
        issues_id_that_other_user_is_referring_to_through_reviews_pull_request(user)

      user.assigned_issues.where.not(id: issues_id_referenced_by_other_users).destroy_all
    end

    def issues_id_that_other_user_is_assigning_to(user)
      issues_id = user.assigned_issues.ids
      Issue.joins(:assigns).where(id: issues_id).where('assigns.user_id != ?', user.id).ids
    end

    def issues_id_that_other_user_is_referring_to_through_assigns_pull_request(user)
      issues_id = user.assigned_issues.ids
      Issue.joins(pull_requests: :assigns)
           .where(id: issues_id)
           .where('assigns.assignable_type = ? AND assigns.user_id != ?', 'PullRequest', user.id)
           .ids
    end

    def issues_id_that_other_user_is_referring_to_through_reviews_pull_request(user)
      issues_id = user.assigned_issues.ids
      Issue.joins(pull_requests: :reviews)
           .where(id: issues_id)
           .where('reviews.user_id != ?', user.id)
           .ids
    end

    def destory_assigned_pull_requests_not_referenced_by_other_users(user)
      pull_requests_id = user.assigned_pull_requests.ids
      pull_requests_id_referenced_by_other_users =
        PullRequest.joins(:assigns, :reviews)
                   .where('assigns.assignable_id in (?) and assigns.user_id != ? or reviews.reviewable_id in (?)', pull_requests_id, user.id, pull_requests_id)
                   .ids

      user.assigned_pull_requests.where.not(id: pull_requests_id_referenced_by_other_users).destroy_all
    end
  end
end
