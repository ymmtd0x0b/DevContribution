class Repositories::Issues::CreateController < ApplicationController
  def index
    @repositories = current_user.registed_repositories
    @repository = @repositories.find(params[:repository_id])
    @issues = current_user.created_issues.where(repository_id: @repository.id).order(:created_at).page(params[:page])

    render 'repositories/issues/index'
  end
end
