# frozen_string_literal: true

class Users::LoadingController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[show]

  def show
    if session[:newspaper] == 'user_create'
      Newspaper.publish(:user_create, { repository: @repository, user: current_user })
      flash[:success] = 'アカウント連携に成功しました'
    end

    session.delete(:newspaper)
    redirect_to users_issues_path(current_user.login, association: 'assigned')
  end
end
