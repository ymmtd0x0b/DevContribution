class Repository < ApplicationRecord
  belongs_to :user
  has_many :issues, dependent: :destroy
  has_many :wikis,  dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  def assigned_issues
    issues.where(kind: Issue.kinds[:assigned])
  end

  def reviewed_issues
    issues.where(kind: Issue.kinds[:reviewed])
  end

  def created_issues
    issues.where(kind: Issue.kinds[:created])
  end
end
