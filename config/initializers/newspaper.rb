Rails.configuration.to_prepare do
  Newspaper.subscribe(:collaboration_create, LabelRegister.new)
  Newspaper.subscribe(:collaboration_create, CreatedIssueRegister.new)
  Newspaper.subscribe(:collaboration_create, AssignedPullRequestRegister.new)
  Newspaper.subscribe(:collaboration_create, ReviewedPullRequestRegister.new)
  Newspaper.subscribe(:collaboration_create, WikiRegister.new)

  Newspaper.subscribe(:repository_update, LabelUpdater.new)
  Newspaper.subscribe(:repository_update, CreatedIssueUpdater.new)
  Newspaper.subscribe(:repository_update, AssignedPullRequestUpdater.new)
  Newspaper.subscribe(:repository_update, ReviewedPullRequestUpdater.new)
  Newspaper.subscribe(:repository_update, WikiUpdater.new)

  Newspaper.subscribe(:collaboration_destroy, CreatedIssueClear.new)
  Newspaper.subscribe(:collaboration_destroy, AssignedPullRequestClear.new)
  Newspaper.subscribe(:collaboration_destroy, ReviewedPullRequestClear.new)
  Newspaper.subscribe(:collaboration_destroy, WikiClear.new)
end
