class Lazy::FirstLoginController < ApplicationController
  def show
    flash[:success] = 'アカウント連携しました'
    Newspaper.publish(:first_login, current_user)
    redirect_to user_assigned_issues_path(current_user)
  end
end
