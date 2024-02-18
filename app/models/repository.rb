class Repository < ApplicationRecord
  has_many :collaborations, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :pull_requests, dependent: :destroy
  has_many :wikis,  dependent: :destroy
  has_many :labels, dependent: :destroy

  def self.find_or_create_by_api_data!(api_data)
    repository =
      Repository.find_or_create_by!(id: api_data.id) do |repo|
        repo.id = api_data.id
        repo.name = api_data.full_name
      end

    if repository.name != api_data.full_name
      repository.update!(name:)
    end

    repository
  end
end
