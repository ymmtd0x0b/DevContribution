class Repository < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }
end
