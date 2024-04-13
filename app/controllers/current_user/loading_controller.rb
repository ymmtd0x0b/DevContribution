class CurrentUser::LoadingController < ApplicationController
  def show
    if session[:newspaper] == 'user_create'
      Newspaper.publish(:user_create, current_user)
      flash[:success] = 'アカウント連携に成功しました'
    end

    session.delete(:newspaper)
    redirect_to current_user_issues_path(current_user, association: 'assigned')
  end
end
