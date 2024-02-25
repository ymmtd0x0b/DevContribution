class CreatedIssueUpdater
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    issues = Github::Issue.created_by(repository, user)
    return if issues.nil?

    Upsert.issue(issues)
  end
end
