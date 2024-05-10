# frozen_string_literal: true

module Newspaper
  class ReviewedIssueSynchronizer
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      pull_requests = Github::PullRequest.reviewed_by(repository, user)

      issues_number = pull_requests.flat_map(&:issues_number)
      issues = Github::Issue.search_numbers(repository, issues_number)

      synchronize_issues(issues, user)
      synchronize_pull_requests(pull_requests, user)
      synchronize_resolutions(issues, pull_requests)
    end

    private

    def synchronize_issues(issues, user)
      Issue.upsert_all(issues.map(&:to_h)) if issues.any?
      synchronize_labelings(issues)
      synchronize_reviews('Issue', issues, user)
    end

    def synchronize_labelings(issues)
      Labeling.where(issue_id: issues.map(&:id))
              .where.not(label_id: issues.flat_map(&:labels_id))
              .delete_all

      labelings = issues.flat_map(&:create_labelings)
      Labeling.upsert_all(labelings, unique_by: %i[issue_id label_id]) if labelings.any?
    end

    def synchronize_pull_requests(pull_requests, user)
      PullRequest.upsert_all(pull_requests.map(&:to_h)) if pull_requests.any?
      synchronize_reviews('PullRequest', pull_requests, user)
    end

    def synchronize_reviews(model_name, items, user)
      user.reviews.where(reviewable_type: model_name).where.not(reviewable_id: items.map(&:id)).delete_all

      new_reviews = items.map { |item| { reviewable_type: model_name, reviewable_id: item.id, user_id: user.id } }
      Review.insert_all(new_reviews, unique_by: %i[reviewable_id user_id]) if new_reviews.any?
    end

    def synchronize_resolutions(issues, pull_requests)
      Resolution.where(pull_request_id: pull_requests.map(&:id))
                .where.not(issue_id: issues.map(&:id))
                .delete_all

      pseudo_resolutions = pull_requests.flat_map(&:create_pseudo_resolutions)
      new_resolutions = convert_issue_number_to_id(issues, pseudo_resolutions)
      Resolution.insert_all(new_resolutions, unique_by: %i[issue_id pull_request_id]) if new_resolutions.any?
    end

    def convert_issue_number_to_id(issues, pseudo_resolutions)
      pseudo_resolutions.map do |pseudo_resolution|
        found_issue = issues.find { |issue| issue.number == pseudo_resolution[:issue_number] }
        { issue_id: found_issue.id, pull_request_id: pseudo_resolution[:pull_request_id] } if found_issue
      end
    end
  end
end
