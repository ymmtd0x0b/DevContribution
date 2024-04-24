# frozen_string_literal: true

class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  class << self
    def bulk_insert(wikis)
      return nil if wikis.empty?

      wikis_data = wikis.map(&:to_h)
      upsert_all wikis_data, unique_by: :id
    end
  end

  def url
    "#{repository.url}/wiki/#{title}"
  end
end
