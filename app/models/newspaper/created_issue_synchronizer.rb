# frozen_string_literal: true

module Newspaper
  class CreatedIssueSynchronizer
    def call(payload)
      repository = payload[:repository]
      user = payload[:user]

      issues = Github::Issue.created_by(repository, user)
      Issue.synchronize(issues)
    end
  end
end
