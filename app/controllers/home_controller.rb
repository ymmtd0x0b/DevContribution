class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if logged_in?
      if current_user.registed_repositories.present?
        redirect_to repository_issues_assign_index_path(current_user.registed_repositories.first)
      else
        flash[:error] = 'リポジトリが登録されていません'
        redirect_to new_solution_path
      end
    end
  end
end
