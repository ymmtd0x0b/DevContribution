class Repositories::IssuesController < ApplicationController
  def index
    target = params[:target]
    if arrow_targets.include?(target)
      @repositories = current_user.registed_repos
      @repository = @repositories.find(params[:repository_id])
      # @issues = @repository.issues.where('kind = ? and user_id = ?', Issue.kinds[@target.to_sym], current_user.id).order(:created_at).page(params[:page])

      @issues =
        case target
        when 'assigned'
          current_user.assigned_issues(@repository.id).order(:created_at).page(params[:page])
        when 'created'
          current_user.created_issues(@repository.id).order(:created_at).page(params[:page])
        when 'reviewed'
          current_user.reviewed_issues(@repository.id).order(:created_at).page(params[:page])
        end
    else
      redirect_to root_path
    end
  end


  private

  def arrow_targets
    %w[assigned reviewed created]
  end
end
