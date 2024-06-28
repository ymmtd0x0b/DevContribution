# frozen_string_literal: true

module Destroyer::Searchable
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

  def filter_pull_requests_assigned_by_other_users_from(pull_requests_id, user_id)
    PullRequest.joins(:assigns).where('pull_requests.id in (?) and assigns.user_id != ?', pull_requests_id, user_id).ids
  end

  def filter_pull_requests_reviewed_by_other_users_from(pull_requests_id, user_id)
    PullRequest.joins(:reviews).where('pull_requests.id in (?) and reviews.user_id != ?', pull_requests_id, user_id).ids
  end
end
