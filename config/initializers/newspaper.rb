Rails.configuration.to_prepare do
  Newspaper.subscribe(:repository_create, LabelCreator.new)
  Newspaper.subscribe(:repository_create, CreatedIssueCreator.new)
  Newspaper.subscribe(:repository_create, AssignedPullRequestCreator.new)
  Newspaper.subscribe(:repository_create, ReviewedPullRequestCreator.new)
  Newspaper.subscribe(:repository_create, WikiCreator.new)
end
