class RepositoriesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[update]

  def update
    newest_repository = Github::Repository.find_by(id: @repository.id)
    if newest_repository && @repository.update(newest_repository.to_h)
      Newspaper.publish(:repository_update, current_user)
      flash[:success] = '更新に成功しました'
    else
      flash[:error] = '更新に失敗しました'
    end

    redirect_to request.headers[:HTTP_REFERER]
  end
end
