module Newspaper
  class RepositoryCreator
    def call(user)
      if Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID']).nil?
        repository = Github::Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
        Repository.create(id: repository.id, name: repository.name, avatar: repository.avatar)
      end
    end
  end
end
