# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :repository

  class << self
    def synchronize_with_github_by(repository)
      labels = Github::Label.find_by(repository)
      return nil if labels.nil?

      repository.labels.where.not(id: labels.map(&:id)).delete_all
      upsert_all(labels.map(&:to_h), unique_by: %i[repository_id name]) if labels.any?
    end
  end
end
