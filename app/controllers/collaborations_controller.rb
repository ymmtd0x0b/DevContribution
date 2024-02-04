class CollaborationsController < ApplicationController
  before_action :set_repository, only: %i[update destroy]

  def new
    @collaboration = Collaboration.new
    @repositories = Github::Repository.unregisted_list(current_user)
  end

  def create
    repository_id = params[:collaboration][:repository_id]
    if !repository_id.match? /^\d+$/
      redirect_to new_collaboration_path, alert: '無効な選択です。再度、選択してください'
      return
    end

    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    repo = client.repo(repository_id.to_i)
    if repo.nil?
      redirect_to new_collaboration_path, alert: 'リポジトリが見つかりませんでした。再度、選択してください'
      return
    end

    repository = Repository.find_or_create_by_octokit_data!(id: repo.id, name: repo.full_name)
    collaboration = current_user.collaborations.new(repository:)
    if collaboration.save
      Newspaper.publish(:repository_create, { repository: repository, user: current_user })
      redirect_to repository_issues_assign_index_path(repository), info: 'リポジトリを追加しました'
    else
      redirect_to new_collaboration_path, alert: '登録に失敗しました。再度、選択してください。'
    end
  end

  def update
    Newspaper.publish(:repository_update, { repository: @repository, user: current_user })
    flash[:info] = 'リポジトリ情報を更新しました'
    redirect_to root_path
  end

  def destroy
    collaboration = current_user.collaboration.find_by(repository_id: params[:id])
    collaboration.destroy

    assigns = current_user.assigned_issues(params[:id])
    assigns.destroy_all

    reviews = current_user.reviewed_issues(params[:id])
    reviews.destroy_all

    wikis = current_user.created_wikis(params[:id])
    wikis.destroy_all

    # TODO
    # 登録解除したリポジトリとそのリポジトリの Issue (ログインユーザーが作者)を削除する必要がある。
    # リポジトリは collaboration_table から参照されていなければ削除して良い。
    # Issue は 作成したユーザーが users_table にいない ＆ assigns_table で参照されていない ＆ reviews_table で参照されていない を全て満たしていたら削除して良い。

    redirect_to root_path, info: 'リポジトリの登録情報を削除しました'
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end
end
