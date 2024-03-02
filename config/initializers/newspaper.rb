Rails.configuration.to_prepare do
  Newspaper.subscribe(:registration_create, LabelFetcher.new)
  Newspaper.subscribe(:registration_create, CreatedIssueFetcher.new)
  Newspaper.subscribe(:registration_create, AssignedIssueFetcher.new)
  Newspaper.subscribe(:registration_create, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:registration_create, WikiFetcher.new)

  Newspaper.subscribe(:repository_update, LabelFetcher.new)
  Newspaper.subscribe(:repository_update, CreatedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, AssignedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, WikiFetcher.new)

  Newspaper.subscribe(:registration_destroy, RepositoryDestroyer.new)
  Newspaper.subscribe(:registration_destroy, CreatedIssueDestroyer.new)
  Newspaper.subscribe(:registration_destroy, AssignedIssueDestroyer.new)
  Newspaper.subscribe(:registration_destroy, ReviewedIssueDestroyer.new)
  Newspaper.subscribe(:registration_destroy, WikiDestroyer.new)
end
