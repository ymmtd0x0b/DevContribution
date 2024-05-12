# frozen_string_literal: true

module Newspaper
  class WikiSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      wikis = Git::Wiki.created_by(repository, user)

      user.wikis.where(repository_id: repository.id).where.not(first_commit_hash: wikis.map(&:first_commit_hash)).delete_all
      Wiki.upsert_all(wikis.map(&:to_h), unique_by: %i[repository_id first_commit_hash]) if wikis.any?
    end
  end
end
