class CurrentUser::IssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    refined_issues =
      case params[:association]
      when 'assigned'
        current_user.assigned_issues
      when 'reviewed'
        current_user.reviewed_issues
      else
        current_user.created_issues
      end
    @issues = refined_issues.where(repository_id: @repository.id).order(:created_at)
  end
end
