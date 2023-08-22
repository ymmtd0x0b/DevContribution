class Repositories::IssuesController < ApplicationController
  def index
    @target = params[:target]
    if arrow_targets.include?(@target)
      @repositories = current_user.repositories
      @repository = @repositories.find(params[:repository_id])
      # @assigned_issues = @repository.assigned_issues.order(:created_at).page(params[:page])
      @issues = @repository.issues.where('kind = ?', Issue.kinds[@target.to_sym]).order(:created_at).page(params[:page])
    else
      redirect_to root_path
    end
  end


  private

  def arrow_targets
    %w[assigned reviewed created]
  end
end
