class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to repository_assigned_issues_path(current_user.repositories.first) if session[:user_id]
  end
end
