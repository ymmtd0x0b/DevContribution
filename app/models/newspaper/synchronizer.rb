# frozen_string_literal: true

module Newspaper::Synchronizer
  class << self
    def synchronize_resolutions(pull_requests)
      issues_id = Issue.where(number: pull_requests.flat_map(&:issues_number)).pluck(:id)
      Resolution.where(pull_request_id: pull_requests.map(&:id))
                .where.not(issue_id: issues_id)
                .delete_all

      hash_list = pull_requests.flat_map(&:resolutions)
      Resolution.insert_all(hash_list, unique_by: %i[issue_id pull_request_id]) if hash_list.any?
    end

    def synchronize_reviews(pull_requests, user)
      user.reviews.where.not(pull_request_id: pull_requests.map(&:id)).delete_all

      hash_list = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Review.insert_all(hash_list, unique_by: %i[user_id pull_request_id]) if hash_list.any?
    end
  end
end
