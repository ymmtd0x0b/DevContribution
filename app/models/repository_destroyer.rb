class RepositoryDestroyer
  def call(options = {})
    repository = options[:repository]

    repository.destroy if Solution.where(repository_id: repository.id).empty?
  end
end
