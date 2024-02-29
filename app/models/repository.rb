class Repository < ApplicationRecord
  has_many :collaborations, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :pull_requests, dependent: :destroy
  has_many :wikis,  dependent: :destroy
  has_many :labels, dependent: :destroy

  def self.find_or_create_by_api_data!(api_data)
    id = api_data.id
    name = api_data.name

    Repository.find_or_create_by!(id:) do |repository|
      repository.id = id
      repository.name = name
    end
  end
end
