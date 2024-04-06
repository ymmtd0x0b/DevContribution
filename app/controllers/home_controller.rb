class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to user_issues_path(current_user, association: 'assigned') if logged_in?
  end
end
