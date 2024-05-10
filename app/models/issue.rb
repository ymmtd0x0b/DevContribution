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

  # class << self
  #   def synchronize(issues, with_labeling: true)
  #     return nil if issues.empty?

  #     issue_hash_list = issues.map(&:to_h)
  #     upsert_all issue_hash_list

  #     Labeling.synchronize(issues) if with_labeling
  #   end
  # end

  def resolves_pull_requests_assignee_of(user)
    PullRequest.joins(:assigns).where('assigns.user_id = ? and ? = any (issue_numbers)', user.id, number)
  end

  def resolves_pull_requests_reviewer_of(user)
    PullRequest.joins(:reviews).where('reviews.user_id = ? and ? = any (issue_numbers)', user.id, number)
  end

  def url
    "#{repository.url}/issues/#{number}"
  end

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
