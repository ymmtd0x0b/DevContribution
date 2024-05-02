# frozen_string_literal: true

class Labeling < ApplicationRecord
  belongs_to :issue
  belongs_to :label

  class << self
    def synchronize(issues)
      new_labeling_hash_list = issues.flat_map(&:labeling_of_hash_list)

      delete_all_removed_labelings(issues, new_labeling_hash_list)
      insert_all(new_labeling_hash_list, unique_by: %i[issue_id label_id]) if new_labeling_hash_list.any?
    end

    private

    def delete_all_removed_labelings(issues, new_labeling_hash_list)
      exist_labelings = Labeling.where(issue_id: issues.map(&:id))
      removed_labelings_id = exist_labelings.filter_map { |labeling| labeling.id if new_labeling_hash_list.none?(labeling.to_h) }
      Labeling.where(id: removed_labelings_id).delete_all
    end
  end

  def to_h
    attributes.symbolize_keys.slice(:issue_id, :label_id)
  end
end
