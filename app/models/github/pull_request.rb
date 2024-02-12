module Github
  class PullRequest
    def initialize(pull_request, repository)
      @id = pull_request.id
      @body = pull_request.body
      @url = pull_request.html_url
      @number = pull_request.number
      @repository_id = repository.id
    end

    def to_hash_of_activerecords_attributes
      {
        id: @id,
        repository_id: @repository_id,
        url: @url,
        number: @number
      }
    end

    def references_issue_numbers
      scan_issue_urls&.map { |issue_url| issue_url.slice(/\d+$/) }.uniq
    end

    def hash_list_of_reference(issues)
      references_issue_numbers&.map do |issue_number|
        issue = issues.find { |issue| issue.number == issue_number.to_i }
        { pull_request_id: @id, issue_id: issue.id }
      end
    end

    private

    def scan_issue_urls
      issue_section = @body&.scan(/[Ii]ssue.+概要/m)&.first
      issue_section&.scan(/http.+\/issues\/\d+|#\d+/)
    end
  end
end
