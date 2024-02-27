class ReviewedPullRequestClear
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    reviewed_pull_requests_id = user.reviewed_pull_requests.where(repository_id: repository.id).pluck(:id)
    return if reviewed_pull_requests_id.empty?

    # 自身がレビューしたプルリクは誰かが担当したプルリクでもあるので
    # AssignTable から参照されているか否かで削除する対象が変わる
    if Assign.where(pull_request_id: reviewed_pull_requests_id).present?
      # 参照されていれば、プルリク自体は残してReviewアソシエーションのみを削除する
      user.reviews.where(pull_request_id: reviewed_pull_requests_id).destroy_all
    else
      # 参照されていなければ、プルリク自体を削除する
      # さらに、プルリクに紐付いた Issue の内、作成者が参照しない(このサービスやリポジトリを登録していない)場合は削除して問題ない
      not_referenced_issues_id =
        user.reviewed_issues.where(repository_id: repository.id).filter_map do |issue|
          issue.id if issue.user.nil? or issue.user.collaborations.find_by(repository_id: repository.id).nil?
        end
      user.reviewed_issues.where(id: not_referenced_issues_id).destroy_all

      user.reviewed_pull_requests.where(repository_id: repository.id).destroy_all
    end
  end
end
