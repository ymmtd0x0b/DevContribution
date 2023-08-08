class WikisController < ApplicationController
  def index
    @repository = current_user.repositories.find(params[:repository_id])
    @wikis = @repository.wikis.order(:created_at)
  end
end
