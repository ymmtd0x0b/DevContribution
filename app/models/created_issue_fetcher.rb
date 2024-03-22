class CreatedIssueFetcher
  def call(user)
    repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

    issues = Github::Issue.created_by(repository, user)
    return if issues.nil?

    Upsert.issue(issues)
  end
end
