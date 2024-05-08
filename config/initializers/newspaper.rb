Rails.configuration.to_prepare do
  Newspaper.subscribe(:user_create, Newspaper::LabelCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::AssignedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::ReviewedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::CreatedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::WikiCreator.new)

  Newspaper.subscribe(:repository_update, Newspaper::LabelCreator.new)
  Newspaper.subscribe(:repository_update, Newspaper::AssignedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::ReviewedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::CreatedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::WikiCreator.new)

  Newspaper.subscribe(:user_destroy, Newspaper::AssignedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::ReviewedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::CreatedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::WikiDestroyer.new)
end
