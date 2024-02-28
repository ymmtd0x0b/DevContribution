class Repositories::Issues::AssignController < ApplicationController
  def index
    @registed_repositories = current_user.registed_repositories
    @repository = @registed_repositories.find(params[:repository_id])
    @issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
    @collaboration = current_user.collaborations.find_by(repository_id: @repository.id)

    render 'repositories/issues/index'
  end
end
