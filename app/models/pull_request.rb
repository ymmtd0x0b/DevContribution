class PullRequest < ApplicationRecord
  has_many :references, dependent: :destroy
end
