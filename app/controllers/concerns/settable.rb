module Settable
  def set_repository
    @repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
  end
end
