# frozen_string_literal: true

class PullRequest < ApplicationRecord
  belongs_to :repository

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :assignees, through: :assigns, source: :user

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  class << self
    def synchronize(pull_requests)
      return nil if pull_requests.empty?

      pr_hash_list = pull_requests.map(&:to_h)
      upsert_all pr_hash_list
    end
  end

  def url
    "#{repository.url}/pull/#{number}"
  end
end
