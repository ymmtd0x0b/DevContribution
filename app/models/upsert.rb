class Upsert
  class << self
    def pull_request(pull_requests)
      return nil if pull_requests.empty?

      pull_requests_data = pull_requests.map { |pull_request| pull_request.to_activerecord_attributes }
      PullRequest.upsert_all pull_requests_data, unique_by: :id
    end

    def issue(issues)
      return nil if issues.empty?

      issues_data = issues.map { |issue| issue.to_activerecord_attributes }
      Issue.upsert_all issues_data, unique_by: :id

      # 今回取得したアソシエーションに含まれない、登録済みのアソシエーションを削除する
      issues.each do |issue|
        labels = Labeling.where(issue_id: issue.id).where.not(label_id: issue.labels_id)
        labels.destroy_all unless labels.nil?
      end

      labelings_data = issues.map { |issue| issue.to_association_of_labels }.flatten
      Labeling.upsert_all(labelings_data, unique_by: %i[issue_id label_id]) if labelings_data.present?
    end

    def solution(issues, pull_requests)
      return nil if (pull_requests.empty? or issues.empty?)

      # 今回取得したアソシエーションに含まれない、登録済みのアソシエーションを予め削除する
      pull_requests.each do |pull_request|
        ref = Solution.where(pull_request_id: pull_request.id).where.not(issue_id: pull_request.solutions_issue_numbers)
        ref.destroy_all unless ref.nil?
      end

      solutions_data = pull_requests.map { |pull_request| pull_request.to_association_of_solutions(issues) }.flatten
      Solution.upsert_all solutions_data, unique_by: :issue_id
    end

    def assign(issues, user)
      return nil if (issues.empty? or user.nil?)

      assigns_data = issues.map { |issue| { user_id: user.id, issue_id: issue.id } }
      Assign.upsert_all assigns_data, unique_by: %i[user_id issue_id]
    end

    def review(issues, user)
      return nil if (issues.empty? or user.nil?)

      reviews_data = issues.map { |issue| { user_id: user.id, issue_id: issue.id } }
      Review.upsert_all reviews_data, unique_by: %i[user_id issue_id]
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
