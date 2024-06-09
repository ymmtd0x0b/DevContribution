# frozen_string_literal: true

module Newspaper::Synchronizer
  class << self
    def synchronize_issues(new_issues)
      hash_list = new_issues.map(&:to_h)
      Issue.upsert_all(hash_list) if hash_list.any?
      synchronize_labelings(new_issues)
    end

    def synchronize_pull_requests(new_pull_requests)
      hash_list = new_pull_requests.map(&:to_h)
      PullRequest.upsert_all(hash_list) if hash_list.any?
    end

    def synchronize_resolutions(pull_requests)
      issues_id = Issue.where(number: pull_requests.flat_map(&:issues_number)).pluck(:id)
      Resolution.where(pull_request_id: pull_requests.map(&:id))
                .where.not(issue_id: issues_id)
                .delete_all

      hash_list = pull_requests.flat_map(&:resolutions)
      Resolution.insert_all(hash_list, unique_by: %i[issue_id pull_request_id]) if hash_list.any?
    end

    def synchronize_assigns(model_name, items, user)
      user.assigns.where(assignable_type: model_name).where.not(assignable_id: items.map(&:id)).delete_all

      hash_list = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
      Assign.insert_all(hash_list, unique_by: %i[assignable_id user_id]) if hash_list.any?
    end

    def synchronize_reviews(pull_requests, user)
      user.reviews.where.not(pull_request_id: pull_requests.map(&:id)).delete_all

      hash_list = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Review.insert_all(hash_list, unique_by: %i[user_id pull_request_id]) if hash_list.any?
    end

    private

    def synchronize_labelings(issues)
      Labeling.where(issue_id: issues.map(&:id))
              .where.not(label_id: issues.flat_map(&:labels_id))
              .delete_all

      hash_list = issues.flat_map(&:create_labelings)
      Labeling.upsert_all(hash_list, unique_by: %i[issue_id label_id]) if hash_list.any?
    end
  end
end
