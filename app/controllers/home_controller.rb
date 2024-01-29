class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if logged_in?
      if current_user.registed_repos.present?
        redirect_to repository_issues_path(current_user.registed_repos.first) + '?target=assigned' if session[:user_id]
      else
        flash[:error] = 'リポジトリが登録されていません'
        redirect_to new_repository_path
      end
    end
  end
end
