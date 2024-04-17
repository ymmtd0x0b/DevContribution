class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to users_issues_path(current_user.login, association: 'assigned') if logged_in?
  end
end
