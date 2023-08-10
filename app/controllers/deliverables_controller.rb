class DeliverablesController < ApplicationController
  def index
    @repository = current_user.repositories.find(params[:repository_id])
    @assigned_issues = @repository.assigned_issues.order(:created_at)
    @reviewed_issues = @repository.reviewed_issues.order(:created_at)
    @created_issues = @repository.created_issues.order(:created_at)
    @wikis = @repository.wikis.order(:created_at)
  end
end
