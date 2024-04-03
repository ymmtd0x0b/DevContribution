class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_create_by_github_auth!(request.env['omniauth.auth'])
    session[:user_id] = user.id
    repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
    if repository && repository.contributors.include?(user)
      flash[:info] = 'ログインしました'
    else
      session[:newspaper] = 'user_create'
    end
    redirect_to user_assigned_issues_path(user)
  end

  def destroy
    reset_session
    flash[:info] = 'ログアウトしました'
    redirect_to root_path
  end
end
