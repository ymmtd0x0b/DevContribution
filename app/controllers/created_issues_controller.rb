class CreatedIssuesController < ApplicationController
  def index
    @repository = Repository.find(params[:repository_id])
    @created_issues = @repository.created_issues.order(:created_at)
  end
end
