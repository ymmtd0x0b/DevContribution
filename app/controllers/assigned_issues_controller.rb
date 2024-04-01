class AssignedIssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    if current_user.contributions.find_by(repository_id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
      @issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
      render 'issues/index'
    else
      render 'issues/loading'
    end
  end
end
