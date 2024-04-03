class LoadingController < ApplicationController
  def show
    case session[:newspaper]
    when 'user_create'
      Newspaper.publish(:user_create, current_user)
      flash[:success] = 'アカウント連携に成功しました'
    when 'repository_update'
      # Newspaper.publish(:repository_update, current_user)
      sleep 5
      flash[:success] = '更新に成功しました'
    end

    session.delete(:newspaper)
    redirect_to user_assigned_issues_path(current_user)
  end
end
