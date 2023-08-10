class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  validates :user_id,       presence: true
  validates :repository_id, presence: true
  validates :title,         presence: true

  paginates_per 30
end
