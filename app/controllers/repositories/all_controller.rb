class Repositories::AllController < ApplicationController
  def index
    @registed_repositories = current_user.registed_repositories
    @repository = @registed_repositories.find(params[:repository_id])
    @collaboration = current_user.collaborations.find_by(repository_id: @repository.id)
    @assigned_pull_requests = current_user.assigned_pull_requests.where(repository_id: @repository.id).order(:created_at)
    @reviewed_pull_requests = current_user.reviewed_pull_requests.where(repository_id: @repository.id).order(:created_at)
    @created_issues = current_user.created_issues.where(repository_id: @repository.id).order(:created_at)
    @wikis = current_user.created_wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
