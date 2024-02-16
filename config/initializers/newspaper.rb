Rails.configuration.to_prepare do
  Newspaper.subscribe(:repository_create, LabelCreator.new)
  Newspaper.subscribe(:repository_create, CreatedIssueCreator.new)
  Newspaper.subscribe(:repository_create, AssignedIssueCreator.new)
  Newspaper.subscribe(:repository_create, ReviewedIssueCreator.new)
  Newspaper.subscribe(:repository_create, WikiCreator.new)
end
