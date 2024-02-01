class Repositories::Issues::ReviewController < ApplicationController
  def index
    @repositories = current_user.registed_repos
    @repository = @repositories.find(params[:repository_id])
    @issues = current_user.reviewed_issues(@repository.id).order(:created_at).page(params[:page])

    render 'repositories/issues/index'
  end
end
