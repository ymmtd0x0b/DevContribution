class Insert
  class << self
    def pull_request(pull_requests)
      return nil if pull_requests.empty?

      pull_requests_data = pull_requests.map { |pull_request| pull_request.to_activerecord_attributes }
      PullRequest.insert_all pull_requests_data
    end

    def issue(issues)
      return nil if issues.empty?

      issues_data = issues.map { |issue| issue.to_activerecord_attributes }
      Issue.insert_all issues_data if issues_data.present?

      labelings_data = issues.map { |issue| issue.to_association_of_labels }.flatten
      Labeling.insert_all labelings_data if labelings_data.present?
    end

    def reference(pull_requests, issues)
      return nil if (pull_requests.empty? or issues.empty?)

      references_data = pull_requests.map { |pull_request| pull_request.to_association_of_references(issues) }.flatten
      Reference.insert_all references_data if references_data.present?
    end

    def assign(pull_requests, user)
      return nil if (pull_requests.empty? or user.nil?)

      assigns_data = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Assign.insert_all assigns_data if assigns_data.present?
    end

    def review(pull_requests, user)
      return nil if (pull_requests.empty? or user.nil?)

      reviews_data = pull_requests.map { |pull_request| { pull_request_id: pull_request.id, user_id: user.id } }
      Review.insert_all reviews_data if reviews_data.present?
    end

    def label(labels)
      return nil if labels.empty?

      labels_data = labels.map(&:to_activerecord_attributes)
      Label.insert_all labels_data if labels_data.present?
    end

    def wiki(wikis)
      return nil if wikis.empty?

      wikis_data = wikis.map(&:to_activerecord_attributes)
      Wiki.insert_all wikis_data if wikis_data.present?
    end
  end
end
