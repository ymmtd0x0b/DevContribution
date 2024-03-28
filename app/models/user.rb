class User < ApplicationRecord
  has_many :contributions, dependent: :destroy

  has_many :assigns, dependent: :destroy
  has_many :assigned_issues, through: :assigns, source: :assignable, source_type: "Issue"
  has_many :assigned_pull_requests, through: :assigns, source: :assignable, source_type: 'PullRequest'

  has_many :reviews, dependent: :destroy
  has_many :reviewed_issues, through: :reviews, source: :reviewable, source_type: 'Issue'
  has_many :reviewed_pull_requests, through: :reviews, source: :reviewable, source_type: 'PullRequest'

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
