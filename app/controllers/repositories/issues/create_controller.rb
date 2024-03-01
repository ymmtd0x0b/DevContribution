class Repositories::Issues::CreateController < ApplicationController
  def index
    @registed_repositories = current_user.registed_repositories
    @repository = @registed_repositories.find(params[:repository_id])
    @issues = current_user.created_issues.where(repository_id: @repository.id).order(:created_at)
    @solution = current_user.solutions.find_by(repository_id: @repository.id)

    render 'repositories/issues/index'
  end
end
