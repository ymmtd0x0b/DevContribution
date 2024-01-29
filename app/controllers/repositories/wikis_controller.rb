class Repositories::WikisController < ApplicationController
  def index
    @repositories = current_user.registed_repos
    @repository = @repositories.find(params[:repository_id])
    @wikis = @current_user.created_wikis(params[:repository_id]).order(:created_at).page(params[:page])
  end
end
