class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  def url
    "#{repository.url}/wiki/#{title}"
  end
end
