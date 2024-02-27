class CollaborationsController < ApplicationController
  def new
    @collaboration = Collaboration.new
    @repositories = Github::Repository.not_registed_by(current_user)
  end

  def create
    repository_data = Github::Repository.find_by(id: params[:collaboration][:repository_id])
    repository = Repository.find_or_create_by_api_data!(repository_data)
    collaboration = current_user.collaborations.new(repository_id: repository.id)
    if collaboration.save
      Newspaper.publish(:collaboration_create, { repository: repository, user: current_user })
      redirect_to repository_issues_assign_index_path(repository), info: 'リポジトリを追加しました'
    else
      redirect_to new_collaboration_path, alert: '登録に失敗しました。再度、選択してください。'
    end
  end

  def destroy
    collaboration = current_user.collaborations.find(params[:id])
    if collaboration.destroy
      Newspaper.publish(:collaboration_destroy, { repository: collaboration.repository, user: current_user })
      redirect_to root_path, alert: 'リポジトリの登録解除に成功しました'
    else
      redirect_to root_path, alert: 'リポジトリの登録解除に失敗しました。再度、選択してください。'
    end
  end
end
