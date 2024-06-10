# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy

  has_many :resolutions, dependent: :destroy
  has_many :pull_requests, through: :resolutions

  class << self
    def synchronize(issues)
      hash_list = issues.map(&:to_h)
      upsert_all(hash_list) if hash_list.any?

      Labeling.synchronize(issues)
    end
  end
end
