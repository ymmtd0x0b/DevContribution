class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to user_assigned_issues_path(current_user) if logged_in?
  end
end
