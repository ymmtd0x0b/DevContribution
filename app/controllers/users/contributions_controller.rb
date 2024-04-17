class Users::ContributionsController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @user = User.find_by(login: params[:user_login])
    @assigned_issues = @user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
    @reviewed_issues = @user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)
    @issues = @user.issues.where(repository_id: @repository.id).order(:created_at)
    @wikis = @user.wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
