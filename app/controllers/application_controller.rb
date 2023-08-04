class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  private

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end
end
