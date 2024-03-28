Rails.configuration.to_prepare do
  Newspaper.subscribe(:first_login, Newspaper::RepositoryCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::ContributionCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::LabelCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::AssignedIssueCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::ReviewedIssueCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::CreatedIssueCreator.new)
  Newspaper.subscribe(:first_login, Newspaper::WikiCreator.new)

  Newspaper.subscribe(:repository_update, Newspaper::LabelCreator.new)
  Newspaper.subscribe(:repository_update, Newspaper::AssignedIssueCreator.new)
  Newspaper.subscribe(:repository_update, Newspaper::ReviewedIssueCreator.new)
  Newspaper.subscribe(:repository_update, Newspaper::CreatedIssueCreator.new)
  Newspaper.subscribe(:repository_update, Newspaper::WikiCreator.new)

  Newspaper.subscribe(:user_destroy, Newspaper::AssignedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::ReviewedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::CreatedIssueDestroyer.new)
  Newspaper.subscribe(:user_destroy, Newspaper::WikiDestroyer.new)
end
