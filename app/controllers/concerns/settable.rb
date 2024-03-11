module Settable
  def set_registed_repositories
    @registed_repositories = current_user.registed_repositories
  end

  def set_repository
    @repository = @registed_repositories.find(params[:repository_id])
  end

  def set_registration
    @registration = current_user.registrations.find_by(repository_id: @repository.id)
  end
end
