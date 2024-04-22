# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :logged_in?, :current_user

  private

  def logged_in?
    !!session[:user_id] && User.find_by(id: session[:user_id])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  protected

  def authenticate_user!
    return if logged_in?

    flash[:warning] = 'ログインしてください'
    redirect_to root_path
  end
end
