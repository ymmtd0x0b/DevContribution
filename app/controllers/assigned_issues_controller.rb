class AssignedIssuesController < ApplicationController
  def index
    @repository = current_user.repositories.find(params[:repository_id])
    @assigned_issues = @repository.assigned_issues.order(:created_at)
  end
end
