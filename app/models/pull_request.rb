# frozen_string_literal: true

class PullRequest < ApplicationRecord
  belongs_to :repository

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :assignees, through: :assigns, source: :user

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  has_many :resolutions, dependent: :destroy
  has_many :issues, through: :resolutions

  def assignee?(user)
    assignees.include?(user)
  end

  def reviewer?(user)
    reviewers.include?(user)
  end

  def url
    "#{repository.url}/pull/#{number}"
  end
end
