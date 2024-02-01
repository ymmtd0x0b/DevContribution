class User < ApplicationRecord
  has_many :collaborations, dependent: :destroy
  has_many :registed_repos, through: :collaborations, source: :repository
  has_many :assigns, dependent: :destroy
  has_many :assigned_issues_of_all_repository, through: :assigns, source: :issue
  has_many :reviews, dependent: :destroy
  has_many :reviewed_issues_of_all_repository, through: :reviews, source: :issue
  has_many :created_issues_of_all_repository, class_name: 'Issue'
  has_many :wikis, dependent: :destroy

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

  def created_issues(repository_id)
    created_issues_of_all_repository.where(repository_id:)
  end

  def assigned_issues(repository_id)
    assigned_issues_of_all_repository.where(repository_id:)
  end

  def reviewed_issues(repository_id)
    reviewed_issues_of_all_repository.where(repository_id:)
  end

  def created_wikis(repository_id)
    wikis.where(repository_id:)
  end
end
