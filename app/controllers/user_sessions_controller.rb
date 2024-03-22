class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_create_by_github_auth!(request.env['omniauth.auth'])
    if user.registed_repositories.present?
      flash[:info] = 'ログインしました'
    else
      flash[:success] = 'アカウント連携しました'
      Newspaper.publish(:user_create, user)
    end
    session[:user_id] = user.id
    redirect_to user_assigned_issues_path(user)
  end

  def destroy
    reset_session
    flash[:info] = 'ログアウトしました'
    redirect_to root_path
  end
end
