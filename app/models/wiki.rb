# frozen_string_literal: true

class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  class << self
    def synchronize(user, wikis_on_github)
      user.wikis
          .where.not(first_commit_hash: wikis_on_github.map(&:first_commit_hash))
          .delete_all

      hash_list = wikis_on_github.map(&:to_h)
      upsert_all(hash_list, unique_by: %i[repository_id first_commit_hash]) if hash_list.any?
    end
  end
end
