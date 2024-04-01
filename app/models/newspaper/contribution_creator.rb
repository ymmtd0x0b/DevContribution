module Newspaper
  class ContributionCreator
    def call(user)
      if user.contributions.find_by(repository_id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID']).nil?
        repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
        user.contributions.create(repository_id: repository.id)
      end
    end
  end
end
