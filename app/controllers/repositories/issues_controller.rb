class Repositories::IssuesController < ApplicationController
  def index
    @target = params[:target]
    if arrow_targets.include?(@target)
      @repositories = current_user.repositories
      @repository = @repositories.find(params[:repository_id])
      @issues = @repository.issues.where('kind = ? and user_id = ?', Issue.kinds[@target.to_sym], current_user.id).order(:created_at).page(params[:page])
    else
      redirect_to root_path
    end
  end


  private

  def arrow_targets
    %w[assigned reviewed created]
  end
end
