# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :repository

  validates :name,  presence: true
  validates :color, presence: true

  class << self
    def bulk_insert(labels)
      return nil if labels.empty?

      labels_data = labels.filter(&:valid?).map(&:to_h)
      upsert_all labels_data, unique_by: :id
    end
  end

  def to_h
    attributes.symbolize_keys.slice(:id, :repository_id, :name, :color)
  end
end
