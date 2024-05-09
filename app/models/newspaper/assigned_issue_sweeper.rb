# frozen_string_literal: true

module Newspaper
  class AssignedIssueSweeper
    def call(user)
      destroy_assigned_issues_not_referenced_by_other_users(user)
      destory_assigned_pull_requests_not_referenced_by_other_users(user)
    end

    private

    def destroy_assigned_issues_not_referenced_by_other_users(user)
      issues_id = user.assigned_issues.ids
      issues_id_referenced_by_other_users =
        Issue.joins(:assigns, :reviews)
             .where('assigns.assignable_id in (?) and assigns.user_id != ? or reviews.reviewable_id in (?)', issues_id, user.id, issues_id)
             .ids

      user.assigned_issues.where.not(id: issues_id_referenced_by_other_users).destroy_all
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
