class User < ApplicationRecord
  has_many :solutions, dependent: :destroy
  has_many :registed_repositories, through: :solutions, source: :repository
  has_many :assigns, dependent: :destroy
  has_many :assigned_issues, through: :assigns, source: :issue
  has_many :assigned_pull_requests, through: :assigned_issues, source: :pull_request
  has_many :reviews, dependent: :destroy
  has_many :reviewed_issues, through: :reviews, source: :issue
  has_many :reviewed_pull_requests, through: :reviewed_issues, source: :pull_request
  has_many :created_issues, class_name: 'Issue'
  has_many :created_wikis, dependent: :destroy, class_name: 'Wiki'

  def self.find_or_create_by_github_auth!(auth_hash)
    uid  = auth_hash[:uid]
    name = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    User.find_or_create_by!(id: uid) do |user|
      user.id = uid
      user.name = name
      user.image_url = image_url
    end
  end
end
