class ReviewedIssuesController < ApplicationController
  def index
    @repository = current_user.repositories.find(params[:repository_id])
    @reviewed_issues = @repository.reviewed_issues.order(:created_at)
  end
end
