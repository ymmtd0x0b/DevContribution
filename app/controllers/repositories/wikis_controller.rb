class Repositories::WikisController < ApplicationController
  def index
    @repositories = current_user.registed_repositories
    @repository = @repositories.find(params[:repository_id])
    @wikis = @current_user.created_wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
