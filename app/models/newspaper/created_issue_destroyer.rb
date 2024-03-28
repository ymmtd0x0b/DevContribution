module Newspaper
  class CreatedIssueDestroyer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      user.created_issues.where.missing(:assignee, :reviewers).destroy_all
    end
  end
end
