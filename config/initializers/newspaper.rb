Rails.configuration.to_prepare do
  Newspaper.subscribe(:repository_create, DeliverablesBringer.new)
  Newspaper.subscribe(:repository_update, DeliverablesUpdater.new)
end
