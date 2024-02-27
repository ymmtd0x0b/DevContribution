class RepositoryDestroyer
  def call(options = {})
    repository = options[:repository]

    repository.destroy if Collaboration.where(repository_id: repository.id).empty?
  end
end
