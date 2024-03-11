class RepositoriesController < ApplicationController
  def update
    repository = Repository.find_by(id: params[:id])
    if repository
      Newspaper.publish(:repository_update, { repository: repository, user: current_user })
      flash[:info] = '更新しました'
      redirect_to repository_assigned_issues_path(repository)
    else
      flash[:error] = 'リポジトリが見つかりませんでした'
      redirect_to root_path
    end
  end
end
