# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_initialize_by_github_auth(request.env['omniauth.auth'])
    if !user.new_record?
      flash[:info] = 'ログインしました'
    else
      user.save
      session[:newspaper] = 'user_create'
    end
    session[:user_id] = user.id
    redirect_to users_issues_path(current_user.login, association: 'assigned')
  end

  def destroy
    reset_session
    flash[:info] = 'ログアウトしました'
    redirect_to root_path
  end
end
