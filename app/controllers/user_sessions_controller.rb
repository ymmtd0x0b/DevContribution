class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_create_by_github_auth!(request.env['omniauth.auth'])
    session[:user_id] = user.id
    if !user.new_record?
      flash[:info] = 'ログインしました'
    else
      session[:newspaper] = 'user_create'
    end
    redirect_to "#{user_issues_path(current_user)}?association=assigned"
  end

  def destroy
    reset_session
    flash[:info] = 'ログアウトしました'
    redirect_to root_path
  end
end
