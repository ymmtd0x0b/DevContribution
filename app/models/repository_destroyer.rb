class RepositoryDestroyer
  def call(options = {})
    repository = options[:repository]

    repository.destroy if Registration.where(repository_id: repository.id).empty?
  end
end
