# frozen_string_literal: true

class Users::ContributionsController < ApplicationController
  include Settable
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_repository, only: %i[index]
  before_action :set_user, only: %i[index]

  def index
    if @user
      @assigned_issues = Issue.eager_load(:repository).preload(:labels, pull_requests: %i[repository assignees]).joins(:assigns).where('assigns.user_id = ?', @user.id).order(:id)
      @reviewed_issues = Issue.eager_load(:repository).preload(:labels, pull_requests: %i[repository reviewers]).joins(pull_requests: :reviews).where('reviews.user_id = ?', @user.id).order(:id)
      @issues = Issue.eager_load(:repository).where(user_id: @user.id).order(:id)
      @wikis = Wiki.eager_load(:repository).where(user_id: @user.id).order(:id)

      render :unauthorized_index unless logged_in?
    else
      flash[:error] = 'ユーザーが見つかりませんでした'
      redirect_to root_path
    end
  end
end
