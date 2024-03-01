class SolutionsController < ApplicationController
  def new
    @solution = Solution.new
    @repositories = Github::Repository.not_registed_by(current_user)
  end

  def create
    repository_data = Github::Repository.find_by(id: params[:solution][:repository_id])
    repository = Repository.find_or_create_by_api_data!(repository_data)
    solution = current_user.solutions.new(repository_id: repository.id)
    if solution.save
      Newspaper.publish(:solution_create, { repository: repository, user: current_user })
      redirect_to repository_issues_assign_index_path(repository), info: 'リポジトリを追加しました'
    else
      redirect_to new_solution_path, alert: '登録に失敗しました。再度、選択してください。'
    end
  end

  def destroy
    solution = current_user.solutions.find(params[:id])
    if solution.destroy
      Newspaper.publish(:solution_destroy, { repository: solution.repository, user: current_user })
      redirect_to root_path, alert: 'リポジトリの登録解除に成功しました'
    else
      redirect_to root_path, alert: 'リポジトリの登録解除に失敗しました。再度、選択してください。'
    end
  end
end
