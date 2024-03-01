Rails.configuration.to_prepare do
  Newspaper.subscribe(:solution_create, LabelFetcher.new)
  Newspaper.subscribe(:solution_create, CreatedIssueFetcher.new)
  Newspaper.subscribe(:solution_create, AssignedIssueFetcher.new)
  Newspaper.subscribe(:solution_create, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:solution_create, WikiFetcher.new)

  Newspaper.subscribe(:repository_update, LabelFetcher.new)
  Newspaper.subscribe(:repository_update, CreatedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, AssignedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, WikiFetcher.new)

  Newspaper.subscribe(:solution_destroy, RepositoryDestroyer.new)
  Newspaper.subscribe(:solution_destroy, CreatedIssueDestroyer.new)
  Newspaper.subscribe(:solution_destroy, AssignedIssueDestroyer.new)
  Newspaper.subscribe(:solution_destroy, ReviewedIssueDestroyer.new)
  Newspaper.subscribe(:solution_destroy, WikiDestroyer.new)
end
