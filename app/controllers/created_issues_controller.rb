class CreatedIssuesController < ApplicationController
  def index
    @repository = current_user.repositories.find(params[:repository_id])
    @created_issues = @repository.created_issues.order(:created_at).page(params[:page])
  end
end
