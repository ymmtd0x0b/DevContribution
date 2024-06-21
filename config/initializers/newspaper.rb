Rails.configuration.to_prepare do
  Newspaper.subscribe(:user_create, Synchronizer::Label.new)
  Newspaper.subscribe(:user_create, Synchronizer::AssignedIssue.new)
  Newspaper.subscribe(:user_create, Synchronizer::AssignedPullRequest.new)
  Newspaper.subscribe(:user_create, Synchronizer::ReviewedIssue.new)
  Newspaper.subscribe(:user_create, Synchronizer::ReviewedPullRequest.new)
  Newspaper.subscribe(:user_create, Synchronizer::CreatedIssue.new)
  Newspaper.subscribe(:user_create, Synchronizer::CreatedWiki.new)

  Newspaper.subscribe(:repository_update, Synchronizer::Label.new)
  Newspaper.subscribe(:repository_update, Synchronizer::AssignedIssue.new)
  Newspaper.subscribe(:repository_update, Synchronizer::AssignedPullRequest.new)
  Newspaper.subscribe(:repository_update, Synchronizer::ReviewedIssue.new)
  Newspaper.subscribe(:repository_update, Synchronizer::ReviewedPullRequest.new)
  Newspaper.subscribe(:repository_update, Synchronizer::CreatedIssue.new)
  Newspaper.subscribe(:repository_update, Synchronizer::CreatedWiki.new)

  Newspaper.subscribe(:user_destroy, Destroyer::AssignedIssue.new)
  Newspaper.subscribe(:user_destroy, Destroyer::ReviewedIssue.new)
  Newspaper.subscribe(:user_destroy, Destroyer::CreatedIssue.new)
  Newspaper.subscribe(:user_destroy, Destroyer::Wiki.new)
end
