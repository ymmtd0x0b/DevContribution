# frozen_string_literal: true

module Newspaper
  class CreatedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.created_by(repository, user)
      Issue.synchronize(issues, with_labeling: true)
    end
  end
end
