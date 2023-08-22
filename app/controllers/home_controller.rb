class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if logged_in?
      if Repository.find_by(user_id: session[:user_id]).presence
        redirect_to repository_issues_path(current_user.repositories.first) + '?target=assigned' if session[:user_id]
      else
        flash[:error] = 'リポジトリが登録されていません'
        redirect_to new_repository_path
      end
    end
  end
end
