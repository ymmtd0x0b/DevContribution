class CurrentUser::ContributionsController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @assigned_issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
    @reviewed_issues = current_user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)
    @issues = current_user.issues.where(repository_id: @repository.id).order(:created_at)
    @wikis = current_user.wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
