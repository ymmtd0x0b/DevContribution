Rails.configuration.to_prepare do
  Newspaper.subscribe(:user_create, RepositoryCreator.new)
  Newspaper.subscribe(:user_create, RegistrationCreator.new)
  Newspaper.subscribe(:user_create, LabelFetcher.new)
  Newspaper.subscribe(:user_create, CreatedIssueFetcher.new)
  Newspaper.subscribe(:user_create, AssignedIssueFetcher.new)
  Newspaper.subscribe(:user_create, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:user_create, WikiFetcher.new)

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
