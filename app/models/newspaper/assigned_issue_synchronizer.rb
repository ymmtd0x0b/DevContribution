# frozen_string_literal: true

module Newspaper
  class AssignedIssueSynchronizer
    include Synchronizable

    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      synchronize_issues(issues)
      synchronize_assigns('Issue', issues, user)
    end
  end
end
