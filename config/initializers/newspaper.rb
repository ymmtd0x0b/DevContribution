Rails.configuration.to_prepare do
  Newspaper.subscribe(:user_create, Newspaper::LabelCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::ContributionCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::AssignedIssueCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::ReviewedIssueCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::CreatedIssueCreator.new)
  Newspaper.subscribe(:user_create, Newspaper::WikiCreator.new)

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
