# frozen_string_literal: true

class Resolution < ApplicationRecord
  belongs_to :issue
  belongs_to :pull_request

  # class << self
  #   def synchronize(issues, pull_requests, exist_resolutions)
  #     resolve_hash_list = relate_issues_to_pull_requests(issues, pull_requests)
  #     delete_all_removed_resolves(exist_resolutions, resolve_hash_list)
  #     insert_all(resolve_hash_list, unique_by: %i[issue_id pull_request_id])
  #   end

  #   private

  #   def relate_issues_to_pull_requests(issues, pull_requests)
  #     pull_requests.flat_map do |pull_request|
  #       pull_request.issues_number.filter_map do |issue_number|
  #         found_issue = issues.find { |issue| issue.number == issue_number.to_i }
  #         { issue_id: found_issue.id, pull_request_id: pull_request.id } if found_issue
  #       end
  #     end
  #   end

  #   def delete_all_removed_resolves(exist_resolutions, new_resolution_hash_list)
  #     removed_resolve_id_list = exist_resolutions.filter_map { |resolution| resolution.id if new_resolution_hash_list.none?(resolution.to_h) }
  #     where(id: removed_resolve_id_list).delete_all
  #   end
  # end

  def to_h
    attributes.symbolize_keys.slice(:issue_id, :pull_request_id)
  end
end
