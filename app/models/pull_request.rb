class PullRequest < ApplicationRecord
  has_many :solutions, dependent: :destroy
  has_many :issues, through: :solutions

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :assignee, through: :assigns, source: :user

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  def number
    "##{File.basename url}"
  end
end
