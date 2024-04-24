# frozen_string_literal: true

class Labeling < ApplicationRecord
  belongs_to :issue
  belongs_to :label

  class << self
    def bulk_insert(issues)
      new_labeling_hash_list = issues.map(&:labelings_to_h).flatten
      destroy_lost_labelings(issues, new_labeling_hash_list)
      upsert_all new_labeling_hash_list, unique_by: %i[issue_id label_id] if new_labeling_hash_list.any?
    end

    private

    def destroy_lost_labelings(issues, new_labeling_hash_list)
      if new_labeling_hash_list.empty?
        Labeling.where(issue_id: issues.map(&:id)).delete_all
      else
        exists_labelings = Labeling.where(issue_id: issues.map(&:id))
        lost_labelings = exists_labelings.filter { |exists_labeling| new_labeling_hash_list.none? exists_labeling.to_h }
        Labeling.where(id: lost_labelings.map(&:id)).delete_all
      end
    end
  end

  def to_h
    attributes.symbolize_keys.slice(:issue_id, :label_id)
  end
end
