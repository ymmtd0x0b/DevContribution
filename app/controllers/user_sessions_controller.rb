class UserSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(github_id: auth[:uid])
    if user.present?
      message = 'ログインしました'
    else
      user = User.create!(
        github_id: auth[:uid],
        name:      auth[:info][:nickname],
        image_url: auth[:info][:image]
      )
      message = 'アカウント連携しました'
    end
    session[:user_id] = user.id
    redirect_to root_path, notice: message
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
