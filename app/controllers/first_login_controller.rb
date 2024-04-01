class FirstLoginController < ApplicationController
  def show
    flash[:success] = 'アカウント連携に成功しました'
    Newspaper.publish(:first_login, current_user)
    redirect_to user_assigned_issues_path(current_user)
  end
end
