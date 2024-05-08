# frozen_string_literal: true

module Newspaper
  class LabelSynchronizer
    def call(_)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
      Label.synchronize_with_github_by(repository)
    end
  end
end
