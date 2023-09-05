class Repositories::WikisController < ApplicationController
  def index
    @repositories = current_user.repositories
    @repository = @repositories.find(params[:repository_id])
    @wikis = @repository.wikis.where('user_id = ?', current_user.id).order(:created_at).page(params[:page])
  end
end
