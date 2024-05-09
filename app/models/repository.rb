# frozen_string_literal: true

class Repository < ApplicationRecord
  has_many :labels, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :pull_requests, dependent: :destroy
  has_many :wikis, dependent: :destroy

  class << self
    def find_and_create_by_octokit(name: nil, with_label: false)
      found_repository = Github::Repository.find_by(name:)

      repository =
        create!(id: found_repository.id,
                name: found_repository.name,
                url: found_repository.url,
                avatar_url: found_repository.avatar_url)

      Label.synchronize_with_github_by(repository) if with_label
    end
  end
end
