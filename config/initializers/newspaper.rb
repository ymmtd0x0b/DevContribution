Rails.configuration.to_prepare do
  Newspaper.subscribe(:repository_create, LabelRegister.new)
  Newspaper.subscribe(:repository_create, CreatedIssueRegister.new)
  Newspaper.subscribe(:repository_create, AssignedPullRequestRegister.new)
  Newspaper.subscribe(:repository_create, ReviewedPullRequestRegister.new)
  Newspaper.subscribe(:repository_create, WikiRegister.new)
end
