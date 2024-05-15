# frozen_string_literal: true

module Newspaper
  class AssignedIssueSynchronizer
    include Synchronizable

    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      issues = Github::Issue.assigned_by(repository, user)
      pull_requests = Github::PullRequest.assigned_by(repository, user)

      synchronize_issues(issues)
      synchronize_assigns('Issue', issues, user)

      synchronize_pull_requests(pull_requests)
      synchronize_assigns('PullRequest', pull_requests, user)

      synchronize_resolutions(issues, pull_requests)
    end

    private

    def synchronize_assigns(model_name, items, user)
      user.assigns.where(assignable_type: model_name).where.not(assignable_id: items.map(&:id)).delete_all

      hash_list = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
      Assign.insert_all(hash_list, unique_by: %i[assignable_id user_id]) if hash_list.any?
    end
  end
end
