# frozen_string_literal: true

class User < ApplicationRecord
  has_many :issues # rubocop:disable Rails/HasManyOrHasOneDependent

  has_many :assigns, dependent: :destroy
  has_many :assigned_issues, through: :assigns, source: :assignable, source_type: 'Issue' do
    def too_other_user
      Issue.joins(:assigns).where(id: ids).where('assigns.user_id != ?', proxy_association.owner.id)
    end

    def by_other_author
      joins(:user).where.not(user_id: proxy_association.owner.id)
    end

    def resolved_pull_requests_assigned_other_user
      Issue.joins(resolutions: :pull_request, pull_requests: :assigns)
           .where('assigns.user_id != ?', proxy_association.owner.id)
    end

    def resolved_pull_requests_reviewed_other_user
      Issue.joins(resolutions: :pull_request, pull_requests: :reviews)
           .where('reviews.user_id != ?', proxy_association.owner.id)
    end
  end
  has_many :assigned_pull_requests, through: :assigns, source: :assignable, source_type: 'PullRequest' do
    def not_referenced_by_other_users
      sql = <<~SQL
        NOT EXISTS (
          SELECT *
          FROM assigns
          WHERE assigns.assignable_id = pull_requests.id AND assigns.user_id != :owner_id
        ) AND NOT EXISTS (
            SELECT *
            FROM reviews
            WHERE reviews.pull_request_id = pull_requests.id AND reviews.user_id != :owner_id
          )
      SQL
      where(sql, owner_id: proxy_association.owner.id)
    end
  end

  has_many :reviews, dependent: :destroy
  has_many :reviewed_pull_requests, through: :reviews, source: :pull_request
  has_many :reviewed_issues, through: :reviewed_pull_requests, source: :issues

  has_many :wikis, dependent: :destroy

  def self.find_or_initialize_by_github_auth(auth_hash)
    uid = auth_hash[:uid]
    login = auth_hash[:info][:nickname]
    name = auth_hash[:info][:name]
    avatar_url = auth_hash[:info][:image]

    User.find_or_initialize_by(id: uid) do |user|
      user.id = uid
      user.login = login
      user.name = name
      user.avatar_url = avatar_url
    end
  end
end
