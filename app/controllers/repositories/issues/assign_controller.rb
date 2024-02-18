class Repositories::Issues::AssignController < ApplicationController
  def index
    @repositories = current_user.registed_repositories
    @repository = @repositories.find(params[:repository_id])
    @issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)

    render 'repositories/issues/index'
  end
end
