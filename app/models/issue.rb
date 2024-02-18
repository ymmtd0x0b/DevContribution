class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings
  has_many :references, dependent: :destroy
  has_many :pull_requests, through: :references

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
