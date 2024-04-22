# frozen_string_literal: true

class Users::ContributionsController < ApplicationController
  include Settable
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_repository, only: %i[index]
  before_action :set_user, only: %i[index]

  def index
    if @user
      @assigned_issues = @user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
      @reviewed_issues = @user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)
      @issues = @user.issues.where(repository_id: @repository.id).order(:created_at)
      @wikis = @user.wikis.where(repository_id: @repository.id).order(:created_at)

      render :unauthorized_index unless logged_in?
    else
      flash[:error] = 'ユーザーが見つかりませんでした'
      redirect_to root_path
    end
  end
end
