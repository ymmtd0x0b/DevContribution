class PullRequest < ApplicationRecord
  has_many :solutions, dependent: :destroy
  has_many :issues, through: :solutions
end
