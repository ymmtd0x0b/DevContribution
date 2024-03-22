class RegistrationCreator
  def call(user)
    repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
    user.registrations.create(repository:)
  end
end
