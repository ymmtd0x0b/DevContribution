# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :repository

  class << self
    def synchronize(repository, labels)
      labels_id = labels.map(&:id)
      repository.labels.where.not(id: labels_id).delete_all

      hash_list = labels.map(&:to_h)
      upsert_all hash_list if hash_list.any?
    end
  end
end
