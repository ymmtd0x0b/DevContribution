class Repositories::AllController < ApplicationController
  def index
    @registed_repositories = current_user.registed_repositories
    @repository = @registed_repositories.find(params[:repository_id])
    @solution = current_user.solutions.find_by(repository_id: @repository.id)
    @assigned_issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
    @reviewed_issues = current_user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)
    @created_issues = current_user.created_issues.where(repository_id: @repository.id).order(:created_at)
    @wikis = current_user.created_wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
