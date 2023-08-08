Rails.configuration.to_prepare do
  Newspaper.subscribe(:repository_create, DeliverablesBringer.new)
end
