Rails.configuration.to_prepare do
  Newspaper.subscribe(:collaboration_create, LabelFetcher.new)
  Newspaper.subscribe(:collaboration_create, CreatedIssueFetcher.new)
  Newspaper.subscribe(:collaboration_create, AssignedIssueFetcher.new)
  Newspaper.subscribe(:collaboration_create, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:collaboration_create, WikiFetcher.new)

  Newspaper.subscribe(:repository_update, LabelFetcher.new)
  Newspaper.subscribe(:repository_update, CreatedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, AssignedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, WikiFetcher.new)

  Newspaper.subscribe(:collaboration_destroy, RepositoryDestroyer.new)
  Newspaper.subscribe(:collaboration_destroy, CreatedIssueDestroyer.new)
  Newspaper.subscribe(:collaboration_destroy, AssignedIssueDestroyer.new)
  Newspaper.subscribe(:collaboration_destroy, ReviewedIssueDestroyer.new)
  Newspaper.subscribe(:collaboration_destroy, WikiDestroyer.new)
end
