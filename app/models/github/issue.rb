module Github
  class Issue
    attr_reader :id, :number

    def initialize(issue, repository = nil)
      @id = issue.id
      @user_id = issue.user.id
      @title = issue.title
      @url = issue.html_url
      @created_at = issue.created_at
      @updated_at = issue.updated_at
      @labels = issue.labels
      @repository_url = issue.repository_url

      @repository_id = repository.id if repository.present?
    end

    def number
      @url.slice(/\d+$/).to_i
    end

    def to_hash_of_activerecords_attributes
      {
        id: @id,
        repository_id: @repository_id,
        user_id: @user_id,
        title: @title,
        url: @url,
        created_at: @created_at,
        updated_at: @updated_at
      }
    end

    def hash_list_of_labelings
      @labels.map { |label| { label_id: label.id, issue_id: @id } }
    end

    def repository_name
      @repository_url.delete_prefix('https://api.github.com/repos/')
    end
    class << self
      def save_all_of_created_by(user, repository)
        created_issues = Github::Repository.created_issues(user, repository)

        insert_issues(created_issues)
        insert_labelings(created_issues)
      end

      def save_all_of_assigned_by(user, repository)
        created_pull_requests = Github::Repository.created_pull_requests(user, repository)
        assigned_issue_numbers = created_pull_requests.map { |pull_request| pull_request.references_issue_numbers }.flatten
        assigned_issues = Github::Repository.issues_by_number(repository, assigned_issue_numbers)

        insert_issues(assigned_issues)
        insert_labelings(assigned_issues)
        insert_assigns(assigned_issues, user.id)
        insert_pull_requests(created_pull_requests)
        insert_references(created_pull_requests, assigned_issues)
      end

      def save_all_of_reviewed_by(user, repository)
        reviewed_pull_requests = Github::Repository.reviewed_pull_requests(user, repository)
        reviewed_issue_numbers = reviewed_pull_requests.map { |pull_request| pull_request.references_issue_numbers }.flatten
        reviewed_issues = Github::Repository.issues_by_number(repository, reviewed_issue_numbers)

        insert_issues(reviewed_issues)
        insert_labelings(reviewed_issues)
        insert_reviews(reviewed_issues, user.id)
        insert_pull_requests(reviewed_pull_requests)
        insert_references(reviewed_pull_requests, reviewed_issues)
      end

      private

      def insert_issues(issues)
        issues_data = issues.map(&:to_hash_of_activerecords_attributes)
        ::Issue.insert_all(issues_data) if issues_data.present?
      end

      def insert_labelings(issues)
        labelings_data = issues.map(&:hash_list_of_labelings).flatten
        ::Labeling.insert_all(labelings_data) if labelings_data.present?
      end

      def insert_assigns(issues, user_id)
        assigns_data = issues.map { |issue| { user_id:, issue_id: issue.id } }
        ::Assign.insert_all(assigns_data) if assigns_data.present?
      end

      def insert_reviews(issues, user_id)
        reviews_data = issues.map { |issue| { user_id:, issue_id: issue.id } }
        ::Review.insert_all(reviews_data) if reviews_data.present?
      end

      def insert_pull_requests(pull_requests)
        pull_requests_data = pull_requests.map(&:to_hash_of_activerecords_attributes).flatten
        ::PullRequest.insert_all(pull_requests_data) if pull_requests_data.present?
      end

      def insert_references(pull_requests, issues)
        references_data = pull_requests.map { |pull_request| pull_request.hash_list_of_reference(issues) }.flatten.compact
        ::Reference.insert_all(references_data) if references_data.present?
      end
    end
  end
end
