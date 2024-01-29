class Repositories::DeliverablesController < ApplicationController
  def index
    @repositories = current_user.registed_repos
    @repository = @repositories.find(params[:repository_id])
    @assigned_issues = current_user.assigned_issues(params[:repository_id]).order(:created_at)
    @reviewed_issues = current_user.reviewed_issues(params[:repository_id]).order(:created_at)
    @created_issues = current_user.created_issues(params[:repository_id]).order(:created_at)
    @wikis = current_user.created_wikis(params[:repository_id]).order(:created_at)
  end
end
