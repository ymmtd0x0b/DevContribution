class Issue < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :assignees, through: :assigns, source: :user

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  def resolves_pull_requests_assignee_of(user)
    PullRequest.joins(:assigns).where('assigns.user_id = ? and ? = any (issue_numbers)', user.id ,number)
  end

  def resolves_pull_requests_reviewer_of(user)
    PullRequest.joins(:reviews).where('reviews.user_id = ? and ? = any (issue_numbers)', user.id ,number)
  end

  def url
    "#{repository.url}/issues/#{number}"
  end

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
