class RepositoriesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[update]

  def update
    newest_repository = Github::Repository.find_by(id: @repository.id)
    if @repository.update(newest_repository.to_hash)
      session[:newspaper] = 'repository_update'
    else
      flash[:error] = '更新に失敗しました'
      redirect_to user_issues_path(current_user, association: 'assigned')
    end
  end
end
