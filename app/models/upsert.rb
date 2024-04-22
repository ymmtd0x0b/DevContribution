# frozen_string_literal: true

class Upsert
  class << self
    def pull_request(pull_requests)
      return nil if pull_requests.empty?

      pull_requests_data = pull_requests.map(&:to_h)
      PullRequest.upsert_all pull_requests_data, unique_by: :id
    end

    def issue(issues)
      return nil if issues.empty?

      issues_data = issues.map(&:to_h)
      Issue.upsert_all issues_data, unique_by: :id
    end

    def labeling(issues)
      return nil if issues.empty?

      new_labeling_hash_list = []
      issues.each do |issue|
        issue.labels_id.each do |label_id|
          new_labeling_hash_list << { issue_id: issue.id, label_id: }
        end
      end

      exists_labelings = Labeling.where(issue_id: issues.map(&:id))
      lost_labelings = exists_labelings.reject do |labeling|
        exists_labeling = labeling.attributes.symbolize_keys.slice(:issue_id, :label_id)
        new_labeling_hash_list.include? exists_labeling
      end
      Labeling.where(id: lost_labelings.map(&:id)).destroy_all

      Labeling.upsert_all new_labeling_hash_list, unique_by: %i[issue_id label_id]
    end

    def assign_to_issue(issues, user)
      return nil if issues.empty? || user.nil?

      assigns_data = issues.map { |issue| { assignable_type: 'Issue', assignable_id: issue.id, user_id: user.id } }
      Assign.upsert_all assigns_data, unique_by: %i[assignable_id user_id]
    end

    def assign_to_pull_request(pull_requests, user)
      return nil if pull_requests.empty? || user.nil?

      assigns_data = pull_requests.map { |pull_request| { assignable_type: 'PullRequest', assignable_id: pull_request.id, user_id: user.id } }
      Assign.upsert_all assigns_data, unique_by: %i[assignable_id user_id]
    end

    def review_to_issue(issues, user)
      return nil if issues.empty? || user.nil?

      reviews_data = issues.map { |issue| { reviewable_type: 'Issue', reviewable_id: issue.id, user_id: user.id } }
      Review.upsert_all reviews_data, unique_by: %i[reviewable_id user_id]
    end

    def review_to_pull_request(pull_requests, user)
      return nil if pull_requests.empty? || user.nil?

      reviews_data = pull_requests.map { |pull_request| { reviewable_type: 'PullRequest', reviewable_id: pull_request.id, user_id: user.id } }
      Review.upsert_all reviews_data, unique_by: %i[reviewable_id user_id]
    end

    def label(labels)
      return nil if labels.empty?

      labels_data = labels.map(&:to_activerecord_attributes)
      Label.upsert_all labels_data, unique_by: :id
    end

    def wiki(wikis)
      return nil if wikis.empty?

      wikis_data = wikis.map(&:to_activerecord_attributes)
      Wiki.upsert_all wikis_data, unique_by: :id
    end
  end
end
