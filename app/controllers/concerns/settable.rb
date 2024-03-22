module Settable
  def set_repository
    @repository = Repository.find(ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
  end
end
