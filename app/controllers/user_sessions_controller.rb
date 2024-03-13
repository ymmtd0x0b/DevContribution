class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_create_by_github_auth!(request.env['omniauth.auth'])
    if user.registed_repositories.present?
      path = repository_assigned_issues_path(user.registed_repositories.first)
      flash[:info] = 'ログインしました'
    else
      path = new_registration_path
      flash[:success] = 'アカウント連携しました'
    end
    session[:user_id] = user.id
    redirect_to path
  end

  def destroy
    reset_session
    flash[:info] = 'ログアウトしました'
    redirect_to root_path
  end
end
