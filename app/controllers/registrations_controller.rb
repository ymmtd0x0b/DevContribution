class RegistrationsController < ApplicationController
  def new
    @registration = Registration.new
    @repositories = Github::Repository.not_registed_by(current_user)
  end

  def create
    repository_data = Github::Repository.find_by(id: params[:registration][:repository_id])
    repository = Repository.find_or_create_by_api_data!(repository_data)
    registration = current_user.registrations.new(repository_id: repository.id)
    if registration.save
      Newspaper.publish(:registration_create, { repository: repository, user: current_user })
      flash[:success] = 'リポジトリを追加しました'
      redirect_to repository_issues_assign_index_path(repository)
    else
      flash[:error] = '登録に失敗しました。再度、選択してください。'
      redirect_to new_registration_path
    end
  end

  def destroy
    registration = current_user.registrations.find(params[:id])
    if registration.destroy
      Newspaper.publish(:registration_destroy, { repository: registration.repository, user: current_user })
      flash[:success] = 'リポジトリの登録解除に成功しました'
      redirect_to root_path
    else
      flash[:error] = 'リポジトリの登録解除に失敗しました。再度、選択してください。'
      redirect_to root_path
    end
  end
end
