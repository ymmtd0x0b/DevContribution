class CreatedIssueRegister
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    issues = Github::Issue.created_by(repository, user)
    return if issues.nil?

    Insert.issue(issues)
  end
end
