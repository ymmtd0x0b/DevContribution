class PullRequest < ApplicationRecord
  belongs_to :repository

  has_many :assigns, as: :assignable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy

  def url
    "#{repository.url}/pull/#{number}"
  end
end
