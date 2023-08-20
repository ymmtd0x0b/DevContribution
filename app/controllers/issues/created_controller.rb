class Issues::CreatedController < ApplicationController
  def index
    @repositories = current_user.repositories
    @repository = @repositories.find(params[:repository_id])
    @created_issues = @repository.created_issues.order(:created_at).page(params[:page])
  end
end
