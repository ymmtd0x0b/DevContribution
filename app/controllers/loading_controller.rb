class LoadingController < ApplicationController
  def show
    case session[:newspaper]
    when 'user_create'
      Newspaper.publish(:user_create, current_user)
      flash[:success] = 'アカウント連携に成功しました'
      path = user_issues_path(current_user, association: 'assigned')
    when 'repository_update'
      Newspaper.publish(:repository_update, current_user)
      flash[:success] = '更新に成功しました'
      path = request.headers[:HTTP_REFERER]
    end

    session.delete(:newspaper)
    redirect_to path
  end
end
