class RepositoriesController < ApplicationController
  before_action :set_repository, only: %i[update destroy]

  def new
    @repository = Repository.new
    @repositories = contributed_repositries
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.user_id = current_user.id

    if @repository.save
      Newspaper.publish(:repository_create, { repository: @repository, user: current_user })
      redirect_to "#{repository_issues_path(@repository)}?target=assigned", info: 'リポジトリを追加しました'
    else
      @repositories = contributed_repositries
      if @repository.name.empty?
        flash.now[:danger] = 'リポジトリが選択されていません'
      else
        flash.now[:warning] = '選択されたリポジトリは登録済みです'
      end
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Newspaper.publish(:repository_update, { repository: @repository, user: current_user })
    flash[:info] = 'リポジトリ情報を更新しました'
    redirect_to root_path
  end

  def destroy
    @repository.destroy

    redirect_to root_path, info: 'リポジトリを削除しました'
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end

    def repository_params
      params.require(:repository).permit(:name)
    end

    def contributed_repositries
      client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
      user_involves_issues = client.search_issues("is:issue is:pr involves:#{current_user.name}")
      list_repository_url = user_involves_issues.items.map(&:repository_url).uniq

      repositories =
        list_repository_url.map do |repository_url|
          repository_name = repository_url.gsub('https://api.github.com/repos/', '')
          if current_user.repositories.find_by(name: repository_name).nil?
            repository = client.repository(repository_name)
            {
              name:        repository.full_name,
              description: repository.description,
              avatar:      repository.owner.avatar_url
            }
          end
        end

      repositories.compact
    end
end
