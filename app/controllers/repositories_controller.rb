class RepositoriesController < ApplicationController
  before_action :set_repository, only: %i[destroy]

  def new
    @repository = Repository.new
    @repositories = contributed_repositries
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.user_id = current_user.id

    if @repository.save
      Newspaper.publish(:repository_create, { repository: @repository, user: current_user })
      redirect_to repository_assigned_issues_path(@repository), info: 'リポジトリを追加しました'
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

      issues = client.search_issues('is:issue involves:ymmtd0x0b')
      pull_requests = client.search_issues('is:pr involves:ymmtd0x0b')

      issues_and_prs = issues.items + pull_requests.items
      repos_url = issues_and_prs.uniq { |issue| issue.repository_url }.map(&:repository_url)

      repos =
        repos_url.map do |repo_url|
          repo_name = repo_url.gsub('https://api.github.com/repos/', '')
          repo = client.repository(repo_name)
          {
            name: repo.full_name,
            description: repo.description,
            avatar: repo.owner.avatar_url
          }
        end

      repos.filter { |repo| current_user.repositories.find_by(name: repo[:name]).nil? }
    end
end
