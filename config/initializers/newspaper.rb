Rails.configuration.to_prepare do
  Newspaper.subscribe(:first_login, RepositoryCreator.new)
  Newspaper.subscribe(:first_login, RegistrationCreator.new)
  Newspaper.subscribe(:first_login, LabelFetcher.new)
  Newspaper.subscribe(:first_login, CreatedIssueFetcher.new)
  Newspaper.subscribe(:first_login, AssignedIssueFetcher.new)
  Newspaper.subscribe(:first_login, ReviewedIssueFetcher.new)
  Newspaper.subscribe(:first_login, WikiFetcher.new)

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
