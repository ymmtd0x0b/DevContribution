class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :assignee, through: :assigns, source: :user

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  has_many :solution, dependent: :destroy
  has_many :pull_requests, through: :solution do
    def assignee_of(user)
      self.joins(:assigns).where('assigns.user_id = ?', user.id)
    end

    def reviewer_of(user)
      self.joins(:reviews).where('reviews.user_id = ?', user.id)
    end
  end

  def point
    labels.pluck(:name).map(&:to_i).sum
  end

  def number
    File.basename url
  end
end
