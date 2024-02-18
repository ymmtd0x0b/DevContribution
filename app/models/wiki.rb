class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  validates :user_id,       presence: true
  validates :repository_id, presence: true
  validates :title,         presence: true

  def url
    "https://github.com/#{repository.name}/wiki/#{title}"
  end
end
