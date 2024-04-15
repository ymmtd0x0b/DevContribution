class User < ApplicationRecord
  has_many :issues

  has_many :assigns, dependent: :destroy
  has_many :assigned_issues, through: :assigns, source: :assignable, source_type: "Issue"

  has_many :reviews, dependent: :destroy
  has_many :reviewed_issues, through: :reviews, source: :reviewable, source_type: 'Issue'

  has_many :wikis, dependent: :destroy

  def self.find_or_initialize_by_github_auth(auth_hash)
    uid  = auth_hash[:uid]
    login = auth_hash[:extra][:raw_info][:login]
    name = auth_hash[:extra][:raw_info][:name]
    avatar_url = auth_hash[:extra][:raw_info][:avatar_url]

    User.find_or_initialize_by(id: uid) do |user|
      user.id = uid
      user.login = login
      user.name = name
      user.avatar_url = avatar_url
    end
  end
end
