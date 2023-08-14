class AssignedIssuesController < ApplicationController
  def index
    @repositories = current_user.repositories
    @repository = @repositories.find(params[:repository_id])
    @assigned_issues = @repository.assigned_issues.order(:created_at).page(params[:page])
  end
end
