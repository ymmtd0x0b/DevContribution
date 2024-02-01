class Repository < ApplicationRecord
  has_many :collaborations, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :wikis,  dependent: :destroy
  has_many :labels, dependent: :destroy

  def self.find_or_create_by_octokit_data!(id: nil, name: nil)
    repository =
      Repository.find_or_create_by!(id:) do |repo|
        repo.id = id
        repo.name = name
      end

    if repository.name != name
      repository.update!(name:)
    end

    repository
  end
end
