class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if logged_in?
      if current_user.registed_repositories.present?
        redirect_to repository_assigned_issues_path(current_user.registed_repositories.first)
      else
        flash[:warning] = '一覧可能なリポジトリが見つかりませんでした<br><br>登録をお願いします'
        redirect_to new_registration_path
      end
    end
  end
end
