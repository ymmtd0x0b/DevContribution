class DeliverablesUpdater
  def call(options = {})
    options[:repository].issues.destroy_all
    options[:repository].wikis.destroy_all
    DeliverablesBringer.new.call({ repository: options[:repository], user: options[:user] })
  end
end
