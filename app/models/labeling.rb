# frozen_string_literal: true

class Labeling < ApplicationRecord
  belongs_to :issue
  belongs_to :label

  class << self
    def synchronize(issues)
      issues_id = issues.map(&:id)
      labels_id = issues.flat_map(&:labels_id)
      where(issue_id: issues_id).where.not(label_id: labels_id).delete_all

      hash_list = issues.flat_map(&:create_labelings)
      upsert_all(hash_list, unique_by: %i[issue_id label_id]) if hash_list.any?
    end
  end
end
