module Newspaper
  class CreatedIssueDestroyer
    def call(user)
      issues_id = user.issues.ids
      other_users_assigned_issues_id = Assign.where('assignable_id in (?) and user_id != ?', issues_id, user.id).ids
      other_users_reviewed_issues_id = Review.where('reviewable_id in (?) and user_id != ?', issues_id, user.id).ids
      user.issues.where.not(id: other_users_assigned_issues_id + other_users_reviewed_issues_id).destroy_all
    end
  end
end
