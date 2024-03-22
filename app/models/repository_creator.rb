class RepositoryCreator
  def call(user)
    repository = Github::Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
    Repository.create(id: repository.id, name: repository.name, avatar: repository.avatar) if Repository.find_by(id: repository.id).nil?
  end
end
