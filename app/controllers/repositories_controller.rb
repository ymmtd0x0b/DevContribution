class RepositoriesController < ApplicationController
  def update
    repository = Repository.find_by(id: params[:id])
    if repository
      Newspaper.publish(:repository_update, { repository: repository, user: current_user })
      redirect_to repository_issues_assign_index_path(repository), notice: "更新しました"
    else
      flash[:alert] = 'リポジトリが見つかりませんでした'
      redirect_to root_path
    end
  end
end
