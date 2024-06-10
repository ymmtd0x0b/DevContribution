Rails.configuration.to_prepare do
  Newspaper.subscribe(:user_create, Newspaper::AssignedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::AssignedPullRequestSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::ReviewedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::ReviewedPullRequestSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::CreatedIssueSynchronizer.new)
  Newspaper.subscribe(:user_create, Newspaper::WikiSynchronizer.new)

  Newspaper.subscribe(:repository_update, Newspaper::LabelSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::AssignedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::AssignedPullRequestSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::ReviewedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::ReviewedPullRequestSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::CreatedIssueSynchronizer.new)
  Newspaper.subscribe(:repository_update, Newspaper::WikiSynchronizer.new)

  Newspaper.subscribe(:user_destroy, Newspaper::AssignedIssueSweeper.new)
  Newspaper.subscribe(:user_destroy, Newspaper::ReviewedIssueSweeper.new)
  Newspaper.subscribe(:user_destroy, Newspaper::CreatedIssueSweeper.new)
  Newspaper.subscribe(:user_destroy, Newspaper::WikiSweeper.new)
end
