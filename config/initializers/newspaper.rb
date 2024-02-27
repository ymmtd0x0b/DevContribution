Rails.configuration.to_prepare do
  Newspaper.subscribe(:collaboration_create, LabelFetcher.new)
  Newspaper.subscribe(:collaboration_create, CreatedIssueFetcher.new)
  Newspaper.subscribe(:collaboration_create, AssignedPullRequestFetcher.new)
  Newspaper.subscribe(:collaboration_create, ReviewedPullRequestFetcher.new)
  Newspaper.subscribe(:collaboration_create, WikiFetcher.new)

  Newspaper.subscribe(:repository_update, LabelFetcher.new)
  Newspaper.subscribe(:repository_update, CreatedIssueFetcher.new)
  Newspaper.subscribe(:repository_update, AssignedPullRequestFetcher.new)
  Newspaper.subscribe(:repository_update, ReviewedPullRequestFetcher.new)
  Newspaper.subscribe(:repository_update, WikiFetcher.new)

  Newspaper.subscribe(:collaboration_destroy, CreatedIssueClear.new)
  Newspaper.subscribe(:collaboration_destroy, AssignedPullRequestClear.new)
  Newspaper.subscribe(:collaboration_destroy, ReviewedPullRequestClear.new)
  Newspaper.subscribe(:collaboration_destroy, WikiClear.new)
end
