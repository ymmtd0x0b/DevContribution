class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings

  validates :user_id,       presence: true
  validates :repository_id, presence: true
  validates :issue_id,      presence: true
  validates :title,         presence: true
  validates :url,           presence: true
  validates :kind,          presence: true

  enum kind: {
    assigned: 0,
    reviewed: 1,
    created:  2
  }

  paginates_per 30

  def point
    labels.each do |label|
      # TODO
      # ラベルの中からポイントを探して返す
    end
    0
  end
end
