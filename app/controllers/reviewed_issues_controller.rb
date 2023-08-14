class ReviewedIssuesController < ApplicationController
  def index
    @repositories = current_user.repositories
    @repository = @repositories.find(params[:repository_id])
    @reviewed_issues = @repository.reviewed_issues.order(:created_at).page(params[:page])
  end
end
