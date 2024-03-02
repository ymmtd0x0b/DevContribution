class Repositories::Issues::ReviewController < ApplicationController
  def index
    @registed_repositories = current_user.registed_repositories
    @repository = @registed_repositories.find(params[:repository_id])
    @issues = current_user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)
    @registration = current_user.registrations.find_by(repository_id: @repository.id)

    render 'repositories/issues/index', layout: 'repositories'
  end
end
