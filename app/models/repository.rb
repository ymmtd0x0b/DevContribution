class Repository < ApplicationRecord
  has_many :contributions, dependent: :destroy
  has_many :contributors, through: :contributions, source: :user
  has_many :issues, dependent: :destroy
  has_many :pull_requests, dependent: :destroy
  has_many :wikis,  dependent: :destroy
  has_many :labels, dependent: :destroy
end
