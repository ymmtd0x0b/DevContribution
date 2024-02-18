class PullRequest < ApplicationRecord
  has_many :assigns, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :issues, through: :references
end
