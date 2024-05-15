# frozen_string_literal: true

module Synchronizer
  class << self
    def issues(new_issues)
      hash_list = new_issues.map(&:to_h)
      Issue.upsert_all(hash_list) if hash_list.any?
      synchronize_labelings(new_issues)
    end

    def pull_requests(new_pull_requests)
      hash_list = new_pull_requests.map(&:to_h)
      PullRequest.upsert_all(hash_list) if hash_list.any?
    end

    def assigns(model_name, items, user)
      user.assigns.where(assignable_type: model_name).where.not(assignable_id: items.map(&:id)).delete_all

      hash_list = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
      Assign.insert_all(hash_list, unique_by: %i[assignable_id user_id]) if hash_list.any?
    end

    def reviews(pull_requests, user)
      user.reviews.where.not(pull_request_id: pull_requests.map(&:id)).delete_all

      hash_list = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Review.insert_all(hash_list, unique_by: %i[user_id pull_request_id]) if hash_list.any?
    end

    def resolutions(issues, pull_requests)
      Resolution.where(pull_request_id: pull_requests.map(&:id))
                .where.not(issue_id: issues.map(&:id))
                .delete_all

      pseudo_resolutions = pull_requests.flat_map(&:create_pseudo_resolutions)
      hash_list = convert_issue_number_to_id(issues, pseudo_resolutions)
      Resolution.insert_all(hash_list, unique_by: %i[issue_id pull_request_id]) if hash_list.any?
    end

    private

    def synchronize_labelings(issues)
      Labeling.where(issue_id: issues.map(&:id))
              .where.not(label_id: issues.flat_map(&:labels_id))
              .delete_all

      hash_list = issues.flat_map(&:create_labelings)
      Labeling.upsert_all(hash_list, unique_by: %i[issue_id label_id]) if hash_list.any?
    end

    def convert_issue_number_to_id(issues, pseudo_resolutions)
      pseudo_resolutions.map do |pseudo_resolution|
        found_issue = issues.find { |issue| issue.number == pseudo_resolution[:issue_number] }
        { issue_id: found_issue.id, pull_request_id: pseudo_resolution[:pull_request_id] } if found_issue
      end
    end
  end
end
