# frozen_string_literal: true

module Newspaper
  class AssignedIssueSynchronizer
    def call(payload)
      repository = payload[:repository]
      user = payload[:user]

      issues = Github::Issue.assigned_by(repository, user)
      Issue.synchronize_issues(issues)
      Synchronizer.synchronize_assigns('Issue', issues, user)
    end
  end
end
