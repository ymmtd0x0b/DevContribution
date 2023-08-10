class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  validates :user_id,       presence: true
  validates :repository_id, presence: true
  validates :point,         presence: true
  validates :kind,          presence: true

  enum kind: {
    assigned: 0,
    reviewed: 1,
    created:  2
  }

  paginates_per 30
end
