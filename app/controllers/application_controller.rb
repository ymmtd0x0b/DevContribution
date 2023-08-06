class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :logged_in?, :current_user

  private

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  protected

  def authenticate_user!
    redirect_to root_path, alert: 'ログインしてください' unless logged_in?
  end
end
