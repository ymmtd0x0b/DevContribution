class RepositoriesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[update]

  def update
    newest_repository = Github::Repository.find_by(id: @repository.id)
    if @repository.update(name: newest_repository.name)
      # Newspaper.publish(:repository_update, current_user)
      # flash[:info] = '更新に成功しました'

      session[:newspaper] = 'repository_update'
      # redirect_to user_assigned_issues_path(current_user)
    else
      flash[:error] = '更新に失敗しました'
      redirect_to user_issues_path(current_user, association: 'assigned')
    end
  end
end
