class Repositories::DeliverablesController < ApplicationController
  def index
    @repositories = current_user.repositories
    @repository = @repositories.find(params[:repository_id])
    @assigned_issues = @repository.assigned_issues.order(:created_at)
    @reviewed_issues = @repository.reviewed_issues.order(:created_at)
    @created_issues = @repository.created_issues.order(:created_at)
    @wikis = @repository.wikis.order(:created_at)
  end
end
