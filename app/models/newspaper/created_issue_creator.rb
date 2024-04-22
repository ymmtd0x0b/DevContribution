# frozen_string_literal: true

module Newspaper
  class CreatedIssueCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.created_by(repository, user)
      return if issues.nil?

      Upsert.issue(issues)
      Upsert.labeling(issues)
    end
  end
end
