module Newspaper
  class CreatedIssueDestroyer
    def call(user)
      user.issues.where.missing(:assignee, :reviewers).destroy_all
    end
  end
end
