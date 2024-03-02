class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_or_create_by_github_auth!(request.env['omniauth.auth'])
    if user.registed_repositories.present?
      path = repository_issues_assign_index_path(user.registed_repositories.first)
      message = 'ログインしました'
    else
      path = new_solution_path
      message = 'アカウント連携しました'
    end
    session[:user_id] = user.id
    flash[:success] = message
    redirect_to path
  end

  def destroy
    reset_session
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end
end
