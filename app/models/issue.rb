class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings
  has_many :assigns, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :solution, dependent: :destroy
  has_one :pull_request, through: :solution

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
