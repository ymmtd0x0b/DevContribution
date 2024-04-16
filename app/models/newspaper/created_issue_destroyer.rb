module Newspaper
  class CreatedIssueDestroyer
    def call(user)
      issues_id = user.issues.ids
      other_users_assigned_issues_id = Issue.joins(:assigns).where('assigns.assignable_id in (?) and assigns.user_id != ?', issues_id, user.id).ids
      other_users_reviewed_issues_id = Issue.joins(:reviews).where('reviews.reviewable_id in (?) and reviews.user_id != ?', issues_id, user.id).ids
      user.issues.where.not(id: other_users_assigned_issues_id + other_users_reviewed_issues_id).destroy_all
    end
  end
end
