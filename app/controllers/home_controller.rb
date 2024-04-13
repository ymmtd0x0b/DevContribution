class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to current_user_issues_path(association: 'assigned') if logged_in?
  end
end
