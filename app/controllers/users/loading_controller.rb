# frozen_string_literal: true

class Users::LoadingController < ApplicationController
  def show
    if session[:newspaper] == 'user_create'
      Newspaper.publish(:user_create, current_user)
      flash[:success] = 'アカウント連携に成功しました'
    end

    session.delete(:newspaper)
    redirect_to users_issues_path(current_user.login, association: 'assigned')
  end
end
