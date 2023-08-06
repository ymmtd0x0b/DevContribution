class RepositoriesController < ApplicationController
  before_action :set_repository, only: %i[destroy]

  def new
    @repository = Repository.new
    @repositories = my_starred_repositories
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.user_id = current_user.id

    if @repository.save
      redirect_to root_path, notice: 'リポジトリを追加しました'
    else
      @repositories = my_starred_repositories
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @repository.destroy

    redirect_to root_path, notice: 'リポジトリを削除しました'
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end

    def repository_params
      params.require(:repository).permit(:name)
    end

    def my_starred_repositories
      client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
      starred_repos = client.starred(current_user.name)
      starred_repos.map { |repo| repo.full_name }
    end
end
