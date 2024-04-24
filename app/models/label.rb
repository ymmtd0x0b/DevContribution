# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :repository

  validates :name,  presence: true
  validates :color, presence: true

  class << self
    def bulk_insert(labels)
      return nil if labels.empty?

      labels_data = labels.map(&:to_activerecord_attributes)
      upsert_all labels_data, unique_by: :id
    end
  end
end
