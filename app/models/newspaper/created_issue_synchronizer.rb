# frozen_string_literal: true

module Newspaper
  class CreatedIssueSynchronizer
    include Synchronizable

    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.created_by(repository, user)
      synchronize_issues(issues)
    end
  end
end
